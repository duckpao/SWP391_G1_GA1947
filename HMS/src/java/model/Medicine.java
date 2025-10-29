package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Medicine {
    private String medicineCode;
    private String name;
    private String category;
    private String description;
    private String activeIngredient;
    private String dosageForm;
    private String strength;
    private String unit;
    private String manufacturer;
    private String countryOfOrigin;
    private String drugGroup;
    private String drugType;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<Batches> batches = new ArrayList<>();

    public Medicine() {}

    public Medicine(String medicineCode, String name, String category, String description,
                    String activeIngredient, String dosageForm, String strength, String unit,
                    String manufacturer, String countryOfOrigin, String drugGroup, String drugType,
                    Timestamp createdAt, Timestamp updatedAt) {
        this.medicineCode = medicineCode;
        this.name = name;
        this.category = category;
        this.description = description;
        this.activeIngredient = activeIngredient;
        this.dosageForm = dosageForm;
        this.strength = strength;
        this.unit = unit;
        this.manufacturer = manufacturer;
        this.countryOfOrigin = countryOfOrigin;
        this.drugGroup = drugGroup;
        this.drugType = drugType;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters và setters
    public String getMedicineCode() { return medicineCode; }
    public void setMedicineCode(String medicineCode) { this.medicineCode = medicineCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getActiveIngredient() { return activeIngredient; }
    public void setActiveIngredient(String activeIngredient) { this.activeIngredient = activeIngredient; }

    public String getDosageForm() { return dosageForm; }
    public void setDosageForm(String dosageForm) { this.dosageForm = dosageForm; }

    public String getStrength() { return strength; }
    public void setStrength(String strength) { this.strength = strength; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public String getCountryOfOrigin() { return countryOfOrigin; }
    public void setCountryOfOrigin(String countryOfOrigin) { this.countryOfOrigin = countryOfOrigin; }

    public String getDrugGroup() { return drugGroup; }
    public void setDrugGroup(String drugGroup) { this.drugGroup = drugGroup; }

    public String getDrugType() { return drugType; }
    public void setDrugType(String drugType) { this.drugType = drugType; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public List<Batches> getBatches() { return batches; }
    public void setBatches(List<Batches> batches) { this.batches = batches; }
      public String getDisplayName() {
        StringBuilder display = new StringBuilder(name);
        
        if (strength != null && !strength.trim().isEmpty()) {
            display.append(" - ").append(strength);
        }
        
        if (dosageForm != null && !dosageForm.trim().isEmpty()) {
            display.append(" (").append(dosageForm).append(")");
        }
        
        return display.toString();
    }
    
}
