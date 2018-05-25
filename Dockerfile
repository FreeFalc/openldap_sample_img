FROM ubuntu:18.04

RUN apt-get -y update && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils debconf-utils

ENV LDAP_ROOTPASS password
ENV LDAP_DOMAIN example.com
ENV LDAP_ORGANISATION "Example org"

RUN echo "slapd slapd/internal/generated_adminpw password ${LDAP_ROOTPASS}" | debconf-set-selections \
 && echo "slapd slapd/internal/adminpw password ${LDAP_ROOTPASS}" | debconf-set-selections \
 && echo "slapd slapd/password2 password ${LDAP_ROOTPASS}" | debconf-set-selections \
 && echo "slapd slapd/password1 password ${LDAP_ROOTPASS}" | debconf-set-selections \
 && echo "slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION" | debconf-set-selections \
 && echo "slapd slapd/domain string ${LDAP_DOMAIN}" | debconf-set-selections \
 && echo "slapd shared/organization string ${LDAP_ORGANISATION}" | debconf-set-selections \
 && echo "slapd slapd/backend string MDB" | debconf-set-selections \
 && echo "slapd slapd/purge_database boolean true" | debconf-set-selections \
 && echo "slapd slapd/move_old_database boolean true" | debconf-set-selections \
 && echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections \
 && echo "slapd slapd/no_configuration boolean false" | debconf-set-selections \
 && echo "slapd slapd/dump_database select when needed" | debconf-set-selections \
 && dpkg-reconfigure -f noninteractive slapd

COPY ./add_content.ldif /root
RUN /etc/init.d/slapd start \
 && ldapadd -x -D cn=admin,dc=example,dc=com -w ${LDAP_ROOTPASS} -f /root/add_content.ldif

EXPOSE 389

CMD ["/usr/sbin/slapd", "-h", "ldap:///", "-g", "openldap", "-u", "openldap", "-d", "0" ]
