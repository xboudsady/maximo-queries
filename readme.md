# Maximo Queries

SQL repository, and information for Maximo.

### Database Server
**NOTE:** Only Active Directory Authentication

* mxodata2.ucsf.edu (production)
* qcmxmowdb001.ucsfmedicalcenter.org (development)


## Table of Contents

* How to connect to database
    * Downloading to Excel 
    * Azure Data Studio (Mac)

* Work Order
    * Level 1

* Users
    * How many active accounts in Maximo.
        * User Application - Not Person Application 
    * How 


### Connecting to Database - Azure Data Studio (Mac)

SQL Servers supports different kinds of authentications and protocols: We will use Kerboros, to authenticate.

#### What is Kerberos?

It's a ticketing and key system: you, a user requests a ticket from a store, usually by authenticating to it via a username and password. If you are succeed, you will get a ticket that is stored within your local machine.

Then when you want to access resources like a SQL Server, the client re-ups with the store you got your initial ticket from (to make sure it's still valid), and you get a "key" to access the resource.

The key is then forwarded onto the resource, allowing you to access the thing you were trying to connect to.

Here Active Diretory domain (campus), manages this for you, even on non-Windows machines. It's part of your handshake with the domain controller.

But if you don't authenticate via Active Directory, there's no reason you can't do this manually. You just have to manually request your ticket (and )