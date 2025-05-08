FROM eclipse-temurin:17-jdk

# Set the working directory
WORKDIR /app

# Copy the WAR file into the image
COPY target/LMS-1.war LMS.war

# Extract the WAR contents
RUN mkdir LMS && cd LMS && jar -xvf ../LMS.war

# Set working directory to extracted app
WORKDIR /app/LMS

# Start the Jetty server using the embedded start.jar
CMD ["java", "-jar", "/app/LMS/WEB-INF/lib/start.jar"]
