
# docker image for openldap sample user database

[How to install openldap manually](https://help.ubuntu.com/lts/serverguide/openldap-server.html.en)

###### How to run:

 1. docker build ./ -t openldap
 2. docker run --rm -p 389:389 -d openldap:latest

######Test installation:

```bash
\# LDAP admin binding
ldapsearch -x -LLL -H ldap:/// -b dc=example,dc=com dn -D cn=admin,dc=example,dc=com -w password
```

```bash
\# Regular user binding
ldapsearch -x -LLL -H ldap:/// -b dc=example,dc=com dn -D uid=user1,ou=People,dc=example,dc=com -w password1
```

###### Field for improvement:
 Add ability to load records at start time. Some approaches: 
 1. add volume where files with data stored 
 2. Somehow pass in parameters.