# Crear tres cuentas de usuario con contrasenas
# Deben pertenecer al gruop de development
# Crear carpeta DevelopmentFiles en root

FROM centos:centos7

RUN yum update -y && yum upgrade -y
RUN yum install -y vim

RUN mkdir /DevelopmentFiles
RUN mkdir /Links
WORKDIR /DevelopmentFiles


# Create group
RUN groupadd development && \
  groupadd operations

copy setup setup

RUN chgrp -R development /DevelopmentFiles

RUN useradd -e 2022-12-12 -s /bin/bash -m -G development user1 && \ 
  useradd -e 2022-12-12 -s /bin/bash -m -G development user2 && \
  useradd -e 2022-12-12 -s /bin/bash -m -G development user3

RUN echo "user1:pass" | chpasswd
RUN echo "user2:pass" | chpasswd
RUN echo "user3:pass" | chpasswd

# De sólo lectura para los dos primeros archivos y con acceso a todos
# los usuarios
COPY ./test /DevelopmentFiles/file1 
COPY ./test /DevelopmentFiles/file2
RUN chmod 755 /DevelopmentFiles/file1
RUN chmod 755 /DevelopmentFiles/file2

# De lectura y escritura para los tres siguientes archivos, en los
# cuales solamente el Administrador del sistema podrá accederlos.
# Lectura y escritura - admin exec
COPY ./test /DevelopmentFiles/file3
COPY ./test /DevelopmentFiles/file4
COPY ./test /DevelopmentFiles/file5
#RUN chmod 766

# A los dos siguientes archivos establecerles permiso de sólo lectura y
# escritura para el Usuario 1.
# solo lectura y escritra - user1
COPY ./test /DevelopmentFiles/file6
COPY ./test /DevelopmentFiles/file7
RUN chown user1 file6
RUN chown user1 file7
RUN chmod 670 file6
RUN chmod 670 file7

# Permiso de lectura, escritura y ejecución a los dos siguientes
# archivos para el Usuario 2.
# permiso de lect, esc, ejec, user2
COPY ./test /DevelopmentFiles/file8
COPY ./test /DevelopmentFiles/file9
RUN chown user2 file8
RUN chown user2 file9

# Todo
COPY ./test /DevelopmentFiles/file10
RUN chmod 777 /DevelopmentFiles/file10

RUN ln -sf /DevelopmentFiles/file1 /Links/file1
RUN ln -sf /DevelopmentFiles/file10 /Links/file10

