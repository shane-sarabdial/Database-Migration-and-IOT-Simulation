# Database-Migration-and-IOT-Simulation


In this endeavor, I have undertaken the simulation of a database migration utilizing Amazon Web Services (AWS), coupled with the implementation of Terraform as the chosen Infrastructure as Code (IaC) toolset. The primary objective has been the seamless deployment and orchestration of various critical services, including but not limited to Kinesis Firehose, Amazon S3, AWS Lambda, Amazon EC2 instances, MySQL and PostgreSQL databases, AWS Glue, and Amazon Athena.

The contextual backdrop involves a scenario wherein a multitude of IoT sensors is actively generating substantial volumes of data. The fundamental requirement is the establishment of a robust data pipeline that not only efficiently ingests this continuous data stream but also diligently adheres to the highest standards of security practices. Moreover, the devised solution places paramount importance on resilience in the face of potential operational setbacks.

A pivotal component of this project involves the transition towards a novel database architecture. This transition necessitates a meticulous data migration strategy that ensures the seamless transfer of information. Notably, this migration process must be conducted without impeding the ongoing data write operations to the existing MySQL database. This concurrent migration and data writing paradigm underscores the complexity of the undertaking.

Of equal significance is the security aspect of this project. Given the sensitive nature of the data being handled, direct public internet access to critical ports, notably port 80 used for SSH, is to be avoided at all costs. Striking the right balance between accessibility and security has been a central concern throughout the project.

Below is an architecture design I created to adhere to these policies.


![ProjectArchitecture_final.jpg](./assets/Project%20Architecture_final.jpg)
