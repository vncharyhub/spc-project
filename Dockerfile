FROM openjdk:11-slim
LABEL author="Naresh Chary"
LABEL organization="ADP India Private Limited"
ARG DOWNLOAD_URL="https://s3.console.aws.amazon.com/s3/object/charybucket123?region=ap-south-1&prefix=spring-petclinic-2.4.2.jar"
ENV APPLICATION_PATH="/spring-petclinic.jar"
ENV TEST_ENV="hello"
ADD ${DOWNLOAD_URL} ${APPLICATION_PATH}
EXPOSE 8090
CMD [ "java", "-jar", ${APPLICATION_PATH} ]
