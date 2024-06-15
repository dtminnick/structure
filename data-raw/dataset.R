
sample_data <- data.frame(

  associate = c("Alice", "Bob", "Charlie", "David",
                "Michael", "Jeffrey", "Patti", "Carol",
                "Tom", "Jones"),

  manager = c("Eve", "Eve", "Bob", "Bob",
              "Bob", "Charlie", "Charlie", "Eve",
              "Charlie", "Tom"),

  title = c("Analyst", "Developer", "Manager", "Director",
            "Developer", "Developer", "Developer", "Developer",
            "Developer", "Analyst"),

  center = c("NY", "NY", "SF", "SF",
             "SF", "SF", "SF", "SF",
             "SF", "NY")

)

write.csv(sample_data, "./data/sample_data.csv")
