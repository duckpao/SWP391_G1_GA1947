package util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Logger để lưu logs thanh toán MoMo trong memory
 */
public class PaymentLogger {
    
    private static final List<LogEntry> logs = new ArrayList<>();
    private static final int MAX_LOGS = 100; // Giữ tối đa 100 logs
    
    public static class LogEntry {
        private String timestamp;
        private String type; // INFO, ERROR, REQUEST, RESPONSE
        private String message;
        
        public LogEntry(String type, String message) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            this.timestamp = sdf.format(new Date());
            this.type = type;
            this.message = message;
        }
        
        public String getTimestamp() { return timestamp; }
        public String getType() { return type; }
        public String getMessage() { return message; }
    }
    
    /**
     * Thêm log mới
     */
    public static synchronized void log(String type, String message) {
        logs.add(0, new LogEntry(type, message)); // Thêm vào đầu list
        
        // Giới hạn số lượng logs
        if (logs.size() > MAX_LOGS) {
            logs.remove(logs.size() - 1);
        }
        
        // In ra console luôn
        System.out.println("[" + type + "] " + message);
    }
    
    /**
     * Log INFO
     */
    public static void info(String message) {
        log("INFO", message);
    }
    
    /**
     * Log ERROR
     */
    public static void error(String message) {
        log("ERROR", message);
    }
    
    /**
     * Log REQUEST
     */
    public static void request(String message) {
        log("REQUEST", message);
    }
    
    /**
     * Log RESPONSE
     */
    public static void response(String message) {
        log("RESPONSE", message);
    }
    
    /**
     * Lấy tất cả logs
     */
    public static synchronized List<LogEntry> getAllLogs() {
        return new ArrayList<>(logs);
    }
    
    /**
     * Xóa tất cả logs
     */
    public static synchronized void clearLogs() {
        logs.clear();
        info("Logs cleared");
    }
}