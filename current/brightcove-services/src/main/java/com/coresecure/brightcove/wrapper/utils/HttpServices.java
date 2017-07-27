package com.coresecure.brightcove.wrapper.utils;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.net.HttpURLConnection;
import java.net.ProtocolException;
import java.net.Proxy;
import java.net.URL;
import java.security.AccessController;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivilegedActionException;
import java.security.PrivilegedExceptionAction;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

import org.apache.commons.lang.StringUtils;
import org.osgi.framework.BundleContext;
import org.osgi.framework.FrameworkUtil;
import org.osgi.framework.ServiceReference;

import com.coresecure.brightcove.wrapper.sling.CertificateListService;

public class HttpServices {
    private static Proxy PROXY = Proxy.NO_PROXY;
    private static final String CERTIFICATE_TYPE = "X.509";
    private static final String CA = "ca";
    private static final String TLS = "TLS";

    public static void setProxy(Proxy proxy) {
        if (proxy == null) {
            PROXY = Proxy.NO_PROXY;
        } else {
            PROXY = proxy;
        }
    }

    public static String excuteDelete(String targetURL,
                                      Map<String, String> headers) {
        URL url;
        HttpsURLConnection connection = null;
        String payload = "{}";
        String delResponse = null;
        BufferedReader rd = null;
        DataOutputStream wr = null;
        try {
            // Create connection
            url = new URL(targetURL);
            connection = getSSLConnection(url, targetURL);
            connection.setRequestMethod("DELETE");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Content-Length",
                    "" + Integer.toString(payload.getBytes().length));
            connection.setRequestProperty("Content-Language", "en-US");
            for (String key : headers.keySet()) {
                connection.setRequestProperty(key, headers.get(key));
            }
            connection.setUseCaches(false);
            connection.setDoInput(true);
            connection.setDoOutput(true);

            // Send request
            wr = new DataOutputStream(connection.getOutputStream());
            wr.writeBytes(payload);
            // Fortify Fix for below two lines.
            // wr.flush();
            // wr.close();

            // Get Response
            InputStream is = connection.getInputStream();
            rd = new BufferedReader(new InputStreamReader(is));
            String line;
            StringBuffer response = new StringBuffer();
            while ((line = rd.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            // Fortify Fix for below two lines.
            // rd.close();
            // return response.toString();
            delResponse = response.toString();

        } catch (Exception e) {
            e.printStackTrace();

        } finally {

            if (connection != null) {
                connection.disconnect();
            }
            // Fixed the Fortify Scan -- - HttpServices.java, line 50
            // (Unreleased Resource: Streams) [Hidden]
            if (null != rd) {
                try {
                    rd.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (null != wr) {
                try {
                    wr.flush();
                    wr.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return delResponse;
    }

    public static String excutePost(String targetURL, String payload,
                                    Map<String, String> headers) {
        URL url;
        HttpsURLConnection connection = null;
        String exPostResponse = null;
        BufferedReader rd = null;
        DataOutputStream wr = null;
        try {

            // Create connection
            url = new URL(targetURL);
            connection = getSSLConnection(url, targetURL);

            connection = (HttpsURLConnection) url.openConnection(PROXY);
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type",
                    "application/x-www-form-urlencoded");
            connection.setRequestProperty("Content-Length",
                    "" + Integer.toString(payload.getBytes().length));
            connection.setRequestProperty("Content-Language", "en-US");
            for (String key : headers.keySet()) {
                connection.setRequestProperty(key, headers.get(key));
            }
            connection.setUseCaches(false);
            connection.setDoInput(true);
            connection.setDoOutput(true);

            // Send request
            wr = new DataOutputStream(connection.getOutputStream());
            wr.writeBytes(payload);
            // Fortify Fix for below commented two lines.
            // wr.flush();
            // wr.close();

            // Get Response
            InputStream is = connection.getInputStream();
            rd = new BufferedReader(new InputStreamReader(is));
            String line;
            StringBuffer response = new StringBuffer();
            while ((line = rd.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            // Fortify Fix for below two lines.
            // rd.close();
            // return response.toString();
            exPostResponse = response.toString();

        } catch (Exception e) {
            e.printStackTrace();

        } finally {

            if (connection != null) {
                connection.disconnect();
            }
            // Fixed the Fortify Scan -- HttpServices.java, line 99 (Unreleased
            // Resource: Streams) [Hidden]
            if (null != rd) {
                try {
                    rd.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (null != wr) {
                try {
                    wr.flush();
                    wr.close();
                } catch (IOException e) {

                    e.printStackTrace();
                }
            }
        }
        return exPostResponse;
    }
    
	 /**
     * Workaround for a bug in {@code HttpURLConnection.setRequestMethod(String)}
     * The implementation of Sun/Oracle is throwing a {@code ProtocolException}
     * when the method is other than the HTTP/1.1 default methods. So to use {@code PATCH}
     * and others, we must apply this workaround.
     *
     * See issue http://java.net/jira/browse/JERSEY-639
     */
    private static void setRequestMethodViaJreBugWorkaround(final HttpURLConnection httpURLConnection, final String method) {
        try {
            httpURLConnection.setRequestMethod(method); // Check whether we are running on a buggy JRE
        } catch (final ProtocolException pe) {
            try {
                final Class<?> httpURLConnectionClass = httpURLConnection.getClass();
				AccessController
						.doPrivileged(new PrivilegedExceptionAction<Object>() {
							public Object run() throws NoSuchFieldException,
									IllegalAccessException {
								try {
									httpURLConnection.setRequestMethod(method);
									// Check whether we are running on a buggy
									// JRE
								} catch (final ProtocolException pe) {
									Class<?> connectionClass = httpURLConnection
											.getClass();
									Field delegateField;
									try {
										delegateField = connectionClass
												.getDeclaredField("delegate");
										delegateField.setAccessible(true);
										HttpURLConnection delegateConnection = (HttpURLConnection) delegateField
												.get(httpURLConnection);
										setRequestMethodViaJreBugWorkaround(
												delegateConnection, method);
									} catch (NoSuchFieldException e) {
										// Ignore for now, keep going
									} catch (IllegalArgumentException e) {
										throw new RuntimeException(e);
									} catch (IllegalAccessException e) {
										throw new RuntimeException(e);
									}
									try {
										Field methodField;
										while (connectionClass != null) {
											try {
												methodField = connectionClass
														.getDeclaredField("method");
											} catch (NoSuchFieldException e) {
												connectionClass = connectionClass
														.getSuperclass();
												continue;
											}
											methodField.setAccessible(true);
											methodField.set(httpURLConnection,
													method);
											break;
										}
									} catch (final Exception e) {
										throw new RuntimeException(e);
									}
								}
								return null;
							}
						});
            } catch (final PrivilegedActionException e) {
                final Throwable cause = e.getCause();
                if (cause instanceof RuntimeException) {
                    throw (RuntimeException) cause;
                } else {
                    throw new RuntimeException(cause);
                }
            }
        }
    }

	/**
	 * Method using the HTTP Patch method as required by the CMS API for update_video operation. 
	 * Parameter payload needs to be UTF-8 encoded.
	 * @param targetURL
	 * @param payload (UTF-8 encoded String)
	 * @param headers
	 * @return 
	 */
	public static String executePatch(String targetURL, String payload, Map<String, String> headers) {
		URL url;
		HttpsURLConnection connection = null;
		String exPatchResponse = null;
		BufferedReader rd = null;
		DataOutputStream wr = null;
		try {

			// Create connection
			url = new URL(targetURL);
			connection = getSSLConnection(url, targetURL);

			connection = (HttpsURLConnection) url.openConnection(PROXY);
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("Content-Length", "" + Integer.toString(payload.getBytes().length));
			for (String key : headers.keySet()) {
				connection.setRequestProperty(key, headers.get(key));
			}
			connection.setUseCaches(false);
			connection.setDoInput(true);
			connection.setDoOutput(true);
			setRequestMethodViaJreBugWorkaround(connection, "PATCH");
			// Send request
			wr = new DataOutputStream(connection.getOutputStream());
			wr.write(payload.getBytes());
			// Fortify Fix for below commented two lines.
			// wr.flush();
			// wr.close();

			// Get Response
			InputStream is = connection.getInputStream();
			rd = new BufferedReader(new InputStreamReader(is));
			String line;
			StringBuffer response = new StringBuffer();
			while ((line = rd.readLine()) != null) {
				response.append(line);
				response.append('\r');
			}
			// Fortify Fix for below two lines.
			// rd.close();
			// return response.toString();
			exPatchResponse = response.toString();

		} catch (Exception e) {
			e.printStackTrace();

		} finally {

			if (connection != null) {
				connection.disconnect();
			}
			// Fixed the Fortify Scan -- HttpServices.java, line 99 (Unreleased
			// Resource: Streams) [Hidden]
			if (null != rd) {
				try {
					rd.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (null != wr) {
				try {
					wr.flush();
					wr.close();
				} catch (IOException e) {

					e.printStackTrace();
				}
			}
		}
		return exPatchResponse;
	} 

    public static String excuteGet(String targetURL, String urlParameters,
                                   Map<String, String> headers) {
        URL url;
        HttpsURLConnection connection = null;
        BufferedReader rd = null;
        String exGetResponse = null;
        try {
            // Create connection
            url = new URL(targetURL + "?" + urlParameters);

            connection = getSSLConnection(url, targetURL);

            connection.setRequestMethod("GET");
            connection.setRequestProperty("Content-Type",
                    "application/x-www-form-urlencoded");
            connection.setRequestProperty("Content-Length",
                    "" + Integer.toString(urlParameters.getBytes().length));
            connection.setRequestProperty("Content-Language", "en-US");
            for (String key : headers.keySet()) {
                connection.setRequestProperty(key, headers.get(key));
            }
            connection.setUseCaches(false);
            connection.setDoInput(true);
            connection.setDoOutput(true);
            connection.connect();
            // Get Response
            InputStream is = connection.getInputStream();
            rd = new BufferedReader(new InputStreamReader(is));
            String line;
            StringBuffer response = new StringBuffer();
            while ((line = rd.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            // Fortify Fix for below two lines.
            // rd.close();
            // return response.toString();
            exGetResponse = response.toString();

        } catch (Exception e) {
            e.printStackTrace();

        } finally {

            if (connection != null) {
                connection.disconnect();
            }
            // Fixed the Fortify Scan -- - HttpServices.java, line 191
            // (Unreleased Resource: Streams) [Hidden]
            if (null != rd) {
                try {
                    rd.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return exGetResponse;
    }

    /**
     * This method provide the SSL connection based upon the enable trusted
     * certificate flag.
     *
     * @param url
     * @param targetURL
     * @return
     * @throws IOException
     */
    private static HttpsURLConnection getSSLConnection(URL url, String targetURL)
            throws IOException {

        HttpsURLConnection connection = (HttpsURLConnection) url
                .openConnection(PROXY);
        CertificateListService certificateListService = getServiceReference();
        if (null != certificateListService) {
            String enableCert = certificateListService
                    .getEnableTrustedCertificate();
            String certPath = getCertificatePath(targetURL);

            if (null != enableCert && "YES".equalsIgnoreCase(enableCert)) {
                SSLContext context = getSSlContext(certPath);
                if (null != context) {
                    connection.setSSLSocketFactory(context.getSocketFactory());
                }
            }
        }
        return connection;
    }

    /**
     * This method is used to find the certificate path for the requested url.
     *
     * @param targetURL
     * @return
     */
    private static String getCertificatePath(String targetURL) {
        String certsPath = StringUtils.EMPTY;
        CertificateListService certificateListService = getServiceReference();
        if (null != certificateListService) {
            Map<String, String> certMap = certificateListService
                    .getCertificatePaths();

            for (String urls : certMap.keySet()) {
                if (targetURL.contains(urls)) {
                    certsPath = certMap.get(urls);
                    break;
                }

            }
        }
        return certsPath;
    }

    /**
     * This method is used only to look up the CertificateListService to get the
     * certificate details and enable / disable flag of these certificates.
     *
     * @return
     */
    private static CertificateListService getServiceReference() {
        CertificateListService serviceRef = null;
        BundleContext bundleContext = FrameworkUtil.getBundle(
                CertificateListService.class).getBundleContext();
        if (null != bundleContext) {
            ServiceReference osgiRef = bundleContext
                    .getServiceReference(CertificateListService.class.getName());
            if (null != osgiRef) {
                serviceRef = (CertificateListService) bundleContext
                        .getService(osgiRef);
            }
        }

        return serviceRef;
    }

    /**
     * This method is used to initialize the SSL context to establish the SSL
     * api connection.
     *
     * @param certPath
     * @return
     */
    private static SSLContext getSSlContext(String certPath) {
        SSLContext context = null;
        InputStream caInput = null;
        try {
            if (null != certPath && certPath.length() > 0) {
                // Load CAs from an InputStream
                CertificateFactory cf = CertificateFactory
                        .getInstance(CERTIFICATE_TYPE);
                caInput = new BufferedInputStream(new FileInputStream(certPath));
                Certificate ca = cf.generateCertificate(caInput);
                // Create a KeyStore containing our trusted CAs
                String keyStoreType = KeyStore.getDefaultType();
                KeyStore keyStore = KeyStore.getInstance(keyStoreType);
                keyStore.load(null, null);
                keyStore.setCertificateEntry(CA, ca);
                // Create a TrustManager that trusts the CAs in our KeyStore
                String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
                TrustManagerFactory tmf = TrustManagerFactory
                        .getInstance(tmfAlgorithm);
                tmf.init(keyStore);
                // Create an SSLContext that uses our TrustManager

                context = SSLContext.getInstance(TLS);
                if (null != context) {
                    context.init(null, tmf.getTrustManagers(), null);
                }

            }
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } catch (NoSuchAlgorithmException nae) {
            nae.printStackTrace();
        } catch (KeyStoreException kse) {
            kse.printStackTrace();
        }

        catch (CertificateException ce) {
            ce.printStackTrace();
        } catch (KeyManagementException ke) {
            ke.printStackTrace();
        } finally {
            if (null != caInput) {
                try {
                    caInput.close();
                } catch (IOException ioe) {
                    ioe.printStackTrace();
                }
            }
        }

        return context;
    }
}
