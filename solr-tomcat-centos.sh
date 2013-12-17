#!/bin/bash
 
U_CONF=/etc/tomcat6/tomcat-users.xml
C_LOGG=commons-logging-1.1.3
SLF4J=slf4j-1.7.5
SOLR_V=4.6.0
SOLR=solr-$SOLR_V
TOMCAT_LIB=/usr/share/tomcat6/lib
HOME_SOLR=/home/solr
 
yum install -y java
 
yum install -y tomcat6 tomcat6-webapps tomcat6-admin-webapps
 
service tomcat6 start
 
chkconfig tomcat6 on
 
echo "<?xml version='1.0' encoding='utf-8'?>" > $U_CONF
echo "<tomcat-users>" >> $U_CONF
echo "<role rolename='manager'/>" >> $U_CONF
echo "<user username='admin' password='admin' roles='manager'/>" >> $U_CONF
echo "</tomcat-users>" >> $U_CONF
 
wget -c http://ftp.unicamp.br/pub/apache//commons/logging/binaries/$C_LOGG-bin.tar.gz
tar zxf $C_LOGG-bin.tar.gz
cp $C_LOGG/commons-logging-*.jar $TOMCAT_LIB
 
wget -c http://www.slf4j.org/dist/$SLF4J.tar.gz
tar zxf $SLF4J.tar.gz
cp $SLF4J/slf4j-*.jar $TOMCAT_LIB
 
wget -c http://ftp.unicamp.br/pub/apache/lucene/solr/$SOLR_V/$SOLR.tgz
tar zxf $SOLR.tgz
cp $SOLR/dist/$SOLR.war /usr/share/tomcat6/webapps/solr.war
 
mkdir -p /home/solr
cp -R $SOLR/example/solr/* $HOME_SOLR
chown -R tomcat $HOME_SOLR
 
echo "Incluir em /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml"
echo "<env-entry>"
echo "<env-entry-name>solr/home</env-entry-name>"
echo "<env-entry-value>/home/solr</env-entry-value>"
echo "<env-entry-type>java.lang.String</env-entry-type>"
echo "</env-entry>"
 
service tomcat6 restart
