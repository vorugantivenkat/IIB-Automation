import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.cert.Certificate;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.jms.BytesMessage;
import javax.jms.Connection;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.MessageProducer;
import javax.jms.Queue;
import javax.jms.Session;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.commons.codec.binary.Base64;

public class FileSigningSample {
	private static final String SEND_FUNCTION = "SEND";
	private static final String RECEIVE_FUNCTION = "RECEIVE";
	private static final int RECEIVE_TIMEOUT = 10000;

	public static void sendAndReceive(String function,String fileName,String keyStoreFileName,String keyStorePassword,String keyAlias,String brokerUrl,String queueName,byte[] content, String digitalSignature) {
//		String function = "send";
//		String fileName = "C:/Users/bandaru/Desktop/OAB_DESIGN_DOC_V4/FileSigningSample/SampleRegistrationFile.csv";
//		String keyStoreFileName = "C:/IIBWorkspace/MpclearDigSignissue/testDigSign/OAB.jks";
//		String keyStorePassword = "oab";
//		String keyAlias = "oab_ach";
////		String brokerUrl = "tcp://192.168.1.114:61616";
//		String queueName = "mpc.tst1.regfile.outward";

		if (function.equalsIgnoreCase(SEND_FUNCTION))
			try {
				send(fileName, keyStoreFileName, keyStorePassword, keyAlias, brokerUrl, queueName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		else if (function.equalsIgnoreCase(RECEIVE_FUNCTION))
			try {
				receive(brokerUrl,queueName, keyStoreFileName, keyStorePassword, keyAlias, fileName,content, digitalSignature);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}

	public static void send(String csvFilePath, String keyStoreName, String keyStorePassword, String keyAlias, String brokerUrl, String queueName)
			throws Exception {
		byte[] csvFileContents = readFile(csvFilePath);
		byte[] zippedContents = zip(csvFileContents, Paths.get(csvFilePath).getFileName().toString());
		String digitalSignature = signContent(zippedContents, keyStoreName, keyStorePassword, keyAlias);
		System.out.println("Digital Signature:\n" + digitalSignature);

		Map<String, String> headers = new HashMap<String, String>();
		headers.put("messageId", Paths.get(csvFilePath).getFileName().toString());
		headers.put("messageType", "REGISTRATION_REQUEST");
		headers.put("digitalSignature", digitalSignature);
		sendToQueue(brokerUrl, queueName, zippedContents, headers);
		unzip(zippedContents, "C:/oab/var/MpclearBulkReg/BulkResBackup/req.csv");
	}

	public static byte[] zip(byte[] content, String entryName) throws IOException {
		ByteArrayOutputStream byteArrayOutputStream = null;
		ZipOutputStream zipOutputStream = null;
		byte[] compressedData = null;
		try {
			byteArrayOutputStream = new ByteArrayOutputStream();
			zipOutputStream = new ZipOutputStream(byteArrayOutputStream);
			zipOutputStream.putNextEntry(new ZipEntry(entryName));
			zipOutputStream.write(content);
			zipOutputStream.closeEntry();
		} finally {
			if (byteArrayOutputStream != null)
				byteArrayOutputStream.close();
			if (zipOutputStream != null) {
				zipOutputStream.close();
				compressedData = byteArrayOutputStream.toByteArray();
			}
		}
		return compressedData;
	}

	private static String signContent(byte[] content, String keyStoreFileName, String keyStorePassword, String keyAlias) throws Exception {
		KeyStore keyStore = loadKeyStore(keyStoreFileName, keyStorePassword);
		PrivateKey privateKey = (PrivateKey) keyStore.getKey(keyAlias, keyStorePassword.toCharArray());
		Signature signature = Signature.getInstance("SHA256withRSA");
		signature.initSign(privateKey);
		signature.update(content);
		byte[] signatureBytes = signature.sign();
		return Base64.encodeBase64String(signatureBytes);
	}

	private static KeyStore loadKeyStore(String keyStoreFileName, String keyStorePassword) throws Exception {
		KeyStore keystore = KeyStore.getInstance("JKS");
		try (FileInputStream inputStream = new FileInputStream(keyStoreFileName)) {
			keystore.load(inputStream, keyStorePassword.toCharArray());
		}
		return keystore;
	}

	public static byte[] readFile(String filePath) throws IOException {
		return Files.readAllBytes(Paths.get(filePath));
	}

	public static void sendToQueue(String brokerUrl, String queueName, byte[] messageBytes, Map<String, String> headers) throws JMSException {
		ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory(brokerUrl);
		Connection connection = connectionFactory.createConnection();
		connection.start();
		Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
		Queue queue = session.createQueue(queueName);
		MessageProducer producer = session.createProducer(queue);
		BytesMessage message = session.createBytesMessage();
		message.writeBytes(messageBytes);
		for (Map.Entry<String, String> entry : headers.entrySet())
			message.setStringProperty(entry.getKey(), entry.getValue());
		producer.send(message);
		session.close();
		connection.close();
	}

	private static void receive(String brokerUrl,String queueName,  String keyStoreFileName, String keyStorePassword, String keyAlias,
			String fileName, byte[] content, String digitalSignature) throws Exception {
		

		//System.out.println(String.format("Received message with id: %s", bytesMessage.getStringProperty("messageId")));
		//System.out.println(String.format("Digital signature:\n%s\n", bytesMessage.getStringProperty("digitalSignature")));

		boolean validSignature = verify(content, digitalSignature, keyStoreFileName, keyStorePassword, keyAlias);

		System.out.println(String.format("Digital signature validation results: %s\n", Boolean.toString(validSignature)));
		System.out.println("Decompressing file..");

		unzip(content, fileName);

		System.out.println(String.format("Saving file to %s..", fileName));
	}

	private static boolean verify(byte[] content, String digitalSignature, String keyStoreFileName, String keyStorePassword, String keyAlias)
			throws Exception {
		KeyStore keyStore = loadKeyStore(keyStoreFileName, keyStorePassword);
		Certificate certificate = keyStore.getCertificate(keyAlias);
		Signature signature = Signature.getInstance("SHA256withRSA");
		signature.initVerify(certificate);
		signature.update(content);
		byte[] signatureBytes = Base64.decodeBase64(digitalSignature);
		return signature.verify(signatureBytes);
	}

	private static void unzip(byte[] content, String fileName) throws IOException {
		ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(content);
		ZipInputStream zipInputStream = new ZipInputStream(byteArrayInputStream);
		FileOutputStream fileOutputStream = new FileOutputStream(fileName);

		zipInputStream.getNextEntry();

		int length = 0;
		byte[] buffer = new byte[2048];

		while ((length = zipInputStream.read(buffer)) > 0) {
			fileOutputStream.write(buffer, 0, length);
		}

		fileOutputStream.close();
		zipInputStream.close();
	}

	public static Message listenOnQueue(String brokerUrl, String queueName) throws JMSException {
		ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory(brokerUrl);
		Connection connection = connectionFactory.createConnection();
		connection.start();
		Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
		Queue queue = session.createQueue(queueName);
		MessageConsumer consumer = session.createConsumer(queue);
		Message message = consumer.receive(RECEIVE_TIMEOUT);
		consumer.close();
		session.close();
		connection.close();
		return message;
	}
}
