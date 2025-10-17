package DAO;

import model.SystemConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for SystemConfig operations
 */
public class SystemConfigDAO extends DBContext {

    /**
     * Get all system configurations
     */
    public List<SystemConfig> getAllConfigs() {
        List<SystemConfig> configs = new ArrayList<>();
        String sql = "SELECT config_key, config_value, updated_at FROM SystemConfig ORDER BY config_key";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                SystemConfig config = new SystemConfig();
                config.setConfigKey(rs.getString("config_key"));
                config.setConfigValue(rs.getString("config_value"));
                config.setUpdatedAt(rs.getTimestamp("updated_at"));
                configs.add(config);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return configs;
    }

    /**
     * Get a specific configuration by key
     */
    public SystemConfig getConfigByKey(String key) {
        String sql = "SELECT config_key, config_value, updated_at FROM SystemConfig WHERE config_key = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, key);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemConfig config = new SystemConfig();
                    config.setConfigKey(rs.getString("config_key"));
                    config.setConfigValue(rs.getString("config_value"));
                    config.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return config;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Update or insert a configuration
     */
    public boolean upsertConfig(String key, String value) {
        String sql = "MERGE INTO SystemConfig AS target " +
                     "USING (SELECT ? AS config_key, ? AS config_value) AS source " +
                     "ON target.config_key = source.config_key " +
                     "WHEN MATCHED THEN " +
                     "    UPDATE SET config_value = source.config_value, updated_at = GETDATE() " +
                     "WHEN NOT MATCHED THEN " +
                     "    INSERT (config_key, config_value, updated_at) " +
                     "    VALUES (source.config_key, source.config_value, GETDATE());";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update an existing configuration
     */
    public boolean updateConfig(String key, String value) {
        String sql = "UPDATE SystemConfig SET config_value = ?, updated_at = GETDATE() WHERE config_key = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.setString(2, key);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a configuration
     */
    public boolean deleteConfig(String key) {
        String sql = "DELETE FROM SystemConfig WHERE config_key = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, key);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get configuration value as integer
     */
    public int getConfigValueAsInt(String key, int defaultValue) {
        SystemConfig config = getConfigByKey(key);
        if (config != null && config.getConfigValue() != null) {
            try {
                return Integer.parseInt(config.getConfigValue());
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Get configuration value as string
     */
    public String getConfigValueAsString(String key, String defaultValue) {
        SystemConfig config = getConfigByKey(key);
        return (config != null && config.getConfigValue() != null) 
                ? config.getConfigValue() 
                : defaultValue;
    }
}