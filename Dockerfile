FROM openjdk:11-slim
LABEL author="Naresh Chary"
LABEL organization="ADP India Private Limited"
ARG DOWNLOAD_URL="https://referenceapplicationskhaja.s3.us-west-2.amazonaws.com/spring-petclinic-2.4.2.jar"
ENV APPLICATION_PATH="/spring-petclinic.jar"
ENV TEST_ENV="hello"
ADD ${DOWNLOAD_URL} ${APPLICATION_PATH}
EXPOSE 8090
CMD [ "java", "-jar", ${APPLICATION_PATH} ]
