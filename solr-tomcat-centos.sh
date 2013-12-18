#!/bin/bash
 
U_CONF=/etc/tomcat6/tomcat-users.xml
C_LOGG=commons-logging-1.1.3
SLF4J=slf4j-1.7.5
SOLR_V=4.6.0
SOLR=solr-$SOLR_V
TOMCAT_LIB=/usr/share/tomcat6/lib
HOME_SOLR=/home/solr
 
yum install -y java tomcat6 tomcat6-webapps tomcat6-admin-webapps
 
service tomcat6 start
 
chkconfig tomcat6 on
 
cat <<U_CONF > $U_CONF 
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
<role rolename='manager'/>
<user username='admin' password='admin' roles='manager'/>
</tomcat-users>
U_CONF
 
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
 
cat <<ECHO Incluir em /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml
<env-entry>
<env-entry-name>solr/home</env-entry-name>
<env-entry-value>/home/solr</env-entry-value>
<env-entry-type>java.lang.String</env-entry-type>
</env-entry>
ECHO
 
service tomcat6 restart
