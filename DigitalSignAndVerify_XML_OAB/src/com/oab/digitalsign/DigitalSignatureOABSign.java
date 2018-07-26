package com.oab.digitalsign;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.Security;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

import javax.xml.crypto.dsig.CanonicalizationMethod;
import javax.xml.crypto.dsig.DigestMethod;
import javax.xml.crypto.dsig.Reference;
import javax.xml.crypto.dsig.SignatureMethod;
import javax.xml.crypto.dsig.SignedInfo;
import javax.xml.crypto.dsig.Transform;
import javax.xml.crypto.dsig.XMLSignature;
import javax.xml.crypto.dsig.XMLSignatureFactory;
import javax.xml.crypto.dsig.dom.DOMSignContext;
import javax.xml.crypto.dsig.keyinfo.KeyInfo;
import javax.xml.crypto.dsig.keyinfo.KeyInfoFactory;
import javax.xml.crypto.dsig.keyinfo.X509Data;
import javax.xml.crypto.dsig.spec.C14NMethodParameterSpec;
import javax.xml.crypto.dsig.spec.TransformParameterSpec;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class DigitalSignatureOABSign {

	private static final String MEC_TYPE = "DOM";
	private static final String WHOLE_DOC_URI = "";
	private PrivateKey privateKey;
	private KeyStore ks;
	private String alias;

	public static void main(String arg[]) {
		System.out.println("Message Content is :"+arg[0]);
		System.out.println("keystoreFile is :"+arg[1]);
		System.out.println("keystorePass is :"+arg[2]);
		String resultval = signOABXMLContent(arg[0],arg[1],arg[2]);
		System.out.println(resultval);
	}

	public static String signOABXMLContent(String msgContent, String keystoreFile, String keystorePass) {
		String signedXML = "";
		String signatureValue = "";
		try {
			 

			DigitalSignatureOABSign obj = null;
			
			try {
				obj = new DigitalSignatureOABSign(keystoreFile,keystorePass);
			} catch (NoSuchProviderException e) {
				e.printStackTrace();
			}
			

			signedXML = obj.signXML(msgContent.toString(), false);
	
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = null;
			try{
				
				db = dbf.newDocumentBuilder();
				InputSource is = new InputSource();
				is.setCharacterStream(new StringReader(signedXML));
				
				 try {
	                    Document doc = db.parse(is);
	                    NodeList nl = doc.getElementsByTagName("Signature");
	      
                    signatureValue = nl.item(0).getTextContent();
	
	                } catch (IOException e) {
	                	e.printStackTrace();
	                }
				
			}catch(Exception e){
				e.printStackTrace();
			}
			 
		} catch (Exception e) {
			e.printStackTrace();

		}
		
		//return signedXML;
		System.out.println("Signature is"+signatureValue);
		return signatureValue;
	}

	public DigitalSignatureOABSign(String keystoreFile, String keystorePass) throws KeyStoreException, NoSuchAlgorithmException, CertificateException,
			FileNotFoundException, IOException, UnrecoverableKeyException, NoSuchProviderException {

		try (FileInputStream stream = new FileInputStream(keystoreFile)) {

			this.ks = KeyStore.getInstance("JKS");

			ks.load(stream, keystorePass.toCharArray());

			Enumeration<String> aliases = ks.aliases();

			while (aliases.hasMoreElements()) {
				this.alias = aliases.nextElement();

			}
				@SuppressWarnings("unused")
				X509Certificate certificate = (X509Certificate) ks.getCertificate(alias);
			this.privateKey = (PrivateKey) ks.getKey(alias, keystorePass.toCharArray());

		}
	}
	

	public String signXML(String xmlDocument, boolean includeKeyInfo) {
		Security.addProvider(new BouncyCastleProvider());
		try {
			// Parse the input XML
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			dbf.setNamespaceAware(true);
			Document inputDocument = dbf.newDocumentBuilder().parse(new InputSource(new StringReader(xmlDocument)));

			// Sign the input XML's DOM document
			Document signedDocument = sign(inputDocument, includeKeyInfo);

			// Convert the signedDocument to XML String
			StringWriter stringWriter = new StringWriter();
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer trans = tf.newTransformer();
			trans.transform(new DOMSource(signedDocument), new StreamResult(stringWriter));

			return stringWriter.getBuffer().toString();
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Error while digitally signing the XML document", e);
		}
	}

	private Document sign(Document xmlDoc, boolean includeKeyInfo) throws Exception {

		// Creating the XMLSignature factory.
		XMLSignatureFactory fac = XMLSignatureFactory.getInstance(MEC_TYPE);
		// Creating the reference object, reading the whole document for
		// signing.
		Reference ref = fac.newReference(WHOLE_DOC_URI, fac.newDigestMethod(DigestMethod.SHA256, null),
				Collections.singletonList(fac.newTransform(Transform.ENVELOPED, (TransformParameterSpec) null)), null,
				null);

		// Create the SignedInfo.
		SignedInfo sInfo = fac.newSignedInfo(
				fac.newCanonicalizationMethod(CanonicalizationMethod.INCLUSIVE, (C14NMethodParameterSpec) null),
				fac.newSignatureMethod(SignatureMethod.RSA_SHA1, null), Collections.singletonList(ref));

		if (privateKey == null) {
			throw new RuntimeException(
					"Key could not be read for digital signature. Please check value of signature alias and signature password, and restart the Auth Client");
		}

		// X509Certificate x509Cert = (X509Certificate)
		// keyEntry.getCertificate();
		X509Certificate x509Cert = (X509Certificate) ks.getCertificate(alias);

		KeyInfo kInfo = getKeyInfo(x509Cert, fac);
		DOMSignContext dsc = new DOMSignContext(privateKey, xmlDoc.getDocumentElement());
		XMLSignature signature = fac.newXMLSignature(sInfo, includeKeyInfo ? kInfo : null);
		signature.sign(dsc);

		Node node = dsc.getParent();
		return node.getOwnerDocument();

	}

	@SuppressWarnings("unchecked")
	private KeyInfo getKeyInfo(X509Certificate cert, XMLSignatureFactory fac) {
		// Create the KeyInfo containing the X509Data.
		KeyInfoFactory kif = fac.getKeyInfoFactory();
		@SuppressWarnings("rawtypes")
		List x509Content = new ArrayList();
		x509Content.add(cert.getSubjectX500Principal().getName());
		x509Content.add(cert);
		X509Data xd = kif.newX509Data(x509Content);
		return kif.newKeyInfo(Collections.singletonList(xd));
	}

}
