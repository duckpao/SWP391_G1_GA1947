package model;

import java.sql.Timestamp;

/**
 * Model class for SystemConfig table
 */
public class SystemConfig {
    private String configKey;
    private String configValue;
    private Timestamp updatedAt;

    // Constructors
    public SystemConfig() {
    }

    public SystemConfig(String configKey, String configValue) {
        this.configKey = configKey;
        this.configValue = configValue;
    }

    public SystemConfig(String configKey, String configValue, Timestamp updatedAt) {
        this.configKey = configKey;
        this.configValue = configValue;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getConfigValue() {
        return configValue;
    }

    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "SystemConfig{" +
                "configKey='" + configKey + '\'' +
                ", configValue='" + configValue + '\'' +
                ", updatedAt=" + updatedAt +
                '}';
    }
}