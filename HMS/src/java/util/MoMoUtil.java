package util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class MoMoUtil {
    // Thông tin test của MoMo Sandbox
    private static final String PARTNER_CODE = "MOMOBKUN20180529";
    private static final String ACCESS_KEY = "klm05TvNBzhg7h7j";
    private static final String SECRET_KEY = "at67qH6mk8w5Y1nAyMoYKMWACiEi2bsa";
    private static final String ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";
    
    /**
     * Tạo link thanh toán MoMo
     */
    public static String createPaymentLink(int invoiceId, long amount) throws Exception {
        PaymentLogger.info("========================================");
        PaymentLogger.info("Starting MoMo Payment for Invoice #" + invoiceId);
        PaymentLogger.info("Amount: " + amount + " VND");
        
        try {
            // Tạo các tham số
            String orderId = "INV_" + invoiceId + "_" + System.currentTimeMillis();
            String requestId = orderId;
            String orderInfo = "Thanh toan hoa don #" + invoiceId;
            String returnUrl = "http://localhost:8080/HMS/payment-callback";
            String ipnUrl = "http://localhost:8080/HMS/payment-callback";
            String requestType = "captureWallet";
            String extraData = "";
            
            PaymentLogger.info("OrderId: " + orderId);
            PaymentLogger.info("RequestId: " + requestId);
            PaymentLogger.info("ReturnUrl: " + returnUrl);
            
            // Tạo chuỗi để ký (theo đúng thứ tự alphabet)
            String rawSignature = String.format(
                "accessKey=%s&amount=%d&extraData=%s&ipnUrl=%s&orderId=%s&orderInfo=%s&partnerCode=%s&redirectUrl=%s&requestId=%s&requestType=%s",
                ACCESS_KEY, amount, extraData, ipnUrl, orderId, orderInfo, 
                PARTNER_CODE, returnUrl, requestId, requestType
            );
            
            PaymentLogger.info("Raw Signature String: " + rawSignature);
            
            // Tạo chữ ký HMAC SHA256
            String signature = hmacSHA256(rawSignature, SECRET_KEY);
            PaymentLogger.info("Signature (HMAC-SHA256): " + signature);
            
            // Tạo JSON body
            StringBuilder jsonBody = new StringBuilder();
            jsonBody.append("{");
            jsonBody.append("\"partnerCode\":\"").append(PARTNER_CODE).append("\",");
            jsonBody.append("\"accessKey\":\"").append(ACCESS_KEY).append("\",");
            jsonBody.append("\"requestId\":\"").append(requestId).append("\",");
            jsonBody.append("\"amount\":").append(amount).append(",");
            jsonBody.append("\"orderId\":\"").append(orderId).append("\",");
            jsonBody.append("\"orderInfo\":\"").append(orderInfo).append("\",");
            jsonBody.append("\"redirectUrl\":\"").append(returnUrl).append("\",");
            jsonBody.append("\"ipnUrl\":\"").append(ipnUrl).append("\",");
            jsonBody.append("\"extraData\":\"").append(extraData).append("\",");
            jsonBody.append("\"requestType\":\"").append(requestType).append("\",");
            jsonBody.append("\"signature\":\"").append(signature).append("\",");
            jsonBody.append("\"lang\":\"vi\"");
            jsonBody.append("}");
            
            PaymentLogger.request("JSON Request Body:");
            PaymentLogger.request(formatJson(jsonBody.toString()));
            
            // Gửi request đến MoMo
            PaymentLogger.info("Sending POST request to: " + ENDPOINT);
            String response = sendPostRequest(ENDPOINT, jsonBody.toString());
            
            PaymentLogger.response("JSON Response Body:");
            PaymentLogger.response(formatJson(response));
            
            // Parse JSON thủ công
            String payUrl = extractValueFromJson(response, "payUrl");
            String resultCode = extractValueFromJson(response, "resultCode");
            String message = extractValueFromJson(response, "message");
            
            PaymentLogger.info("ResultCode: " + resultCode);
            PaymentLogger.info("Message: " + message);
            
            if (payUrl != null && !payUrl.isEmpty()) {
                PaymentLogger.info("✅ Payment URL created successfully!");
                PaymentLogger.info("PayUrl: " + payUrl);
                PaymentLogger.info("========================================");
                return payUrl;
            } else {
                String errorMsg = "MoMo API Error [" + resultCode + "]: " + 
                    (message != null ? message : "Unknown error");
                PaymentLogger.error(errorMsg);
                PaymentLogger.error("========================================");
                throw new Exception(errorMsg);
            }
            
        } catch (Exception e) {
            PaymentLogger.error("❌ Exception occurred: " + e.getClass().getName());
            PaymentLogger.error("Error Message: " + e.getMessage());
            
            // Print stack trace to logger
            StackTraceElement[] stackTrace = e.getStackTrace();
            for (int i = 0; i < Math.min(5, stackTrace.length); i++) {
                PaymentLogger.error("  at " + stackTrace[i].toString());
            }
            
            PaymentLogger.error("========================================");
            throw e;
        }
    }
    
    /**
     * Format JSON cho dễ đọc
     */
    private static String formatJson(String json) {
        if (json == null || json.isEmpty()) {
            return "{}";
        }
        
        StringBuilder formatted = new StringBuilder();
        int indent = 0;
        boolean inQuotes = false;
        
        for (char c : json.toCharArray()) {
            switch (c) {
                case '"':
                    formatted.append(c);
                    inQuotes = !inQuotes;
                    break;
                case '{':
                case '[':
                    formatted.append(c);
                    if (!inQuotes) {
                        formatted.append('\n');
                        indent++;
                        formatted.append("  ".repeat(indent));
                    }
                    break;
                case '}':
                case ']':
                    if (!inQuotes) {
                        formatted.append('\n');
                        indent--;
                        formatted.append("  ".repeat(indent));
                    }
                    formatted.append(c);
                    break;
                case ',':
                    formatted.append(c);
                    if (!inQuotes) {
                        formatted.append('\n');
                        formatted.append("  ".repeat(indent));
                    }
                    break;
                case ':':
                    formatted.append(c);
                    if (!inQuotes) {
                        formatted.append(' ');
                    }
                    break;
                default:
                    formatted.append(c);
            }
        }
        
        return formatted.toString();
    }
    
    /**
     * Tạo chữ ký HMAC SHA256
     */
    private static String hmacSHA256(String data, String key) throws Exception {
        Mac sha256 = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        sha256.init(secretKey);
        byte[] hash = sha256.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return bytesToHex(hash);
    }
    
    /**
     * Chuyển byte array sang hex string
     */
    private static String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
    
    /**
     * Gửi POST request
     */
    private static String sendPostRequest(String urlString, String jsonBody) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        // Setup connection
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);
        conn.setConnectTimeout(30000);
        conn.setReadTimeout(30000);
        
        PaymentLogger.info("Connection opened to: " + urlString);
        PaymentLogger.info("Request Method: POST");
        PaymentLogger.info("Content-Type: application/json; charset=UTF-8");
        
        // Send request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
            PaymentLogger.info("Request sent (" + input.length + " bytes)");
        }
        
        // Read response
        int responseCode = conn.getResponseCode();
        String responseMessage = conn.getResponseMessage();
        
        PaymentLogger.info("HTTP Response Code: " + responseCode);
        PaymentLogger.info("HTTP Response Message: " + responseMessage);
        
        StringBuilder response = new StringBuilder();
        
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(
                    responseCode >= 200 && responseCode < 300 ? 
                        conn.getInputStream() : conn.getErrorStream(), 
                    StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
        }
        
        if (response.length() == 0) {
            PaymentLogger.error("⚠️ Empty response from server!");
        }
        
        return response.toString();
    }
    
    /**
     * Parse JSON thủ công - Lấy giá trị từ JSON string
     */
    private static String extractValueFromJson(String json, String key) {
        if (json == null || key == null) {
            return null;
        }
        
        // Tìm key trong JSON
        String searchKey = "\"" + key + "\":\"";
        int startIndex = json.indexOf(searchKey);
        
        if (startIndex == -1) {
            // Thử tìm với format number (không có dấu ngoặc kép)
            searchKey = "\"" + key + "\":";
            startIndex = json.indexOf(searchKey);
            
            if (startIndex == -1) {
                return null;
            }
            
            startIndex += searchKey.length();
            
            // Tìm dấu , hoặc } kết thúc value
            int endIndex = json.indexOf(",", startIndex);
            if (endIndex == -1) {
                endIndex = json.indexOf("}", startIndex);
            }
            
            if (endIndex == -1) {
                return null;
            }
            
            return json.substring(startIndex, endIndex).trim();
        }
        
        // Bỏ qua key và dấu ":"
        startIndex += searchKey.length();
        
        // Tìm dấu " kết thúc value
        int endIndex = json.indexOf("\"", startIndex);
        
        if (endIndex == -1) {
            return null;
        }
        
        return json.substring(startIndex, endIndex);
    }
    
    /**
     * Verify callback signature từ MoMo
     */
    public static boolean verifySignature(String rawData, String signature, String secretKey) {
        try {
            String computedSignature = hmacSHA256(rawData, secretKey);
            return computedSignature.equals(signature);
        } catch (Exception e) {
            PaymentLogger.error("Error verifying signature: " + e.getMessage());
            return false;
        }
    }
}