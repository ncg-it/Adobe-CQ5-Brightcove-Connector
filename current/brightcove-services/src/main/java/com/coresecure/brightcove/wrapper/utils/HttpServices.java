package com.coresecure.brightcove.wrapper.utils;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.Proxy;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

import org.apache.commons.lang3.StringUtils;
import org.osgi.framework.BundleContext;
import org.osgi.framework.FrameworkUtil;
import org.osgi.framework.ServiceReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coresecure.brightcove.wrapper.sling.CertificateListService;

public class HttpServices {
    private static Proxy PROXY = Proxy.NO_PROXY;
    private static final String CERTIFICATE_TYPE = "X.509";
    private static final String CA = "ca";
    private static final String TLS = "TLS";
    private static final Logger LOGGER = LoggerFactory.getLogger(HttpServices.class);

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
                response.append("\r\n");
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

    public static String excuteGet(String targetURL, String urlParameters,
                                   Map<String, String> headers) {
        URL url;
        HttpsURLConnection connection = null;
        BufferedReader rd = null;
        String exGetResponse = null;
        try {
            // Create connection
            url = new URL(targetURL + "?" + urlParameters);
            LOGGER.trace("url: "+targetURL + "?" + urlParameters);

            connection = getSSLConnection(url, targetURL);

            connection.setRequestMethod("GET");
            connection.setRequestProperty("Content-Type",
                    "application/x-www-form-urlencoded");
            connection.setRequestProperty("Content-Length",
                    "" + Integer.toString(urlParameters.getBytes().length));
            connection.setRequestProperty("Content-Language", "en-US");
            for (String key : headers.keySet()) {
                connection.setRequestProperty(key, headers.get(key));
                LOGGER.trace("-H \""+key+": "+headers.get(key)+"\"");
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
                response.append("\r\n");
            }
            LOGGER.trace("response committed!");

            // Fortify Fix for below two lines.
            // rd.close();
            // return response.toString();
            exGetResponse = response.toString();

        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("error! ",e);

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
                    LOGGER.trace("error 2!");

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
