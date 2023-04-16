-- ************************************** Admin

CREATE TABLE Admin
(
 AdminId  serial NOT NULL,
 Name     varchar(50) NOT NULL,
 password varchar(50) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( AdminId )
);


-- ************************************** "User"

CREATE TABLE "User"
(
 UserId   serial NOT NULL,
 Name     varchar(50) NOT NULL,
 password varchar(50) NOT NULL,
 Type     varchar(50) NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( UserId )
);


-- ************************************** Employer

CREATE TABLE Employer
(
 UserId int NOT NULL,
 CONSTRAINT PK_26 PRIMARY KEY ( UserId ),
 CONSTRAINT FK_21 FOREIGN KEY ( UserId ) REFERENCES "User" ( UserId )
);

CREATE INDEX FK_311 ON Employer
(
 UserId
);


-- ************************************** Freelancer

CREATE TABLE Freelancer
(
 UserId int NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( UserId ),
 CONSTRAINT FK_22 FOREIGN KEY ( UserId ) REFERENCES "User" ( UserId )
);

CREATE INDEX FK_215 ON Freelancer
(
 UserId
);


-- ************************************** Resume

CREATE TABLE Resume
(
 ResumeId serial NOT NULL,
 UserId   int NOT NULL,
 CONSTRAINT PK_18 PRIMARY KEY ( ResumeId ),
 CONSTRAINT FK_24_2 FOREIGN KEY ( UserId ) REFERENCES "User" ( UserId )
);

CREATE INDEX FK_208 ON Resume
(
 UserId
);


-- ************************************** Message

CREATE TABLE Message
(
 MessageId serial NOT NULL,
 Text      varchar(60) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( MessageId )
);


-- ************************************** Chat

CREATE TABLE Chat
(
 ChatId     uuid NOT NULL,
 "Date"       json NOT NULL,
 SenderId   int NOT NULL,
 RecieverId int NOT NULL,
 MessageId  int NOT NULL,
 CONSTRAINT PK_7 PRIMARY KEY ( ChatId ),
 CONSTRAINT FK_4 FOREIGN KEY ( MessageId ) REFERENCES Message ( MessageId ),
 CONSTRAINT FK_5 FOREIGN KEY ( RecieverId ) REFERENCES "User" ( UserId ),
 CONSTRAINT FK_29 FOREIGN KEY ( SenderId ) REFERENCES "User" ( UserId )
);

CREATE INDEX FK_200 ON Chat
(
 MessageId
);

CREATE INDEX FK_301 ON Chat
(
 RecieverId
);

CREATE INDEX FK_4 ON Chat
(
 SenderId
);


-- ************************************** ConfirmRegistration

CREATE TABLE ConfirmRegistration
(
 RId     serial NOT NULL,
 "Date"    timestamp NOT NULL,
 AdminId serial NOT NULL,
 UserId  int NOT NULL,
 CONSTRAINT PK_8 PRIMARY KEY ( RId ),
 CONSTRAINT FK_6 FOREIGN KEY ( UserId ) REFERENCES "User" ( UserId ),
 CONSTRAINT FK_24_1 FOREIGN KEY ( AdminId ) REFERENCES Admin ( AdminId )
);

CREATE INDEX FK_201 ON ConfirmRegistration
(
 UserId
);

CREATE INDEX FK_302 ON ConfirmRegistration
(
 AdminId
);


-- ************************************** Education

CREATE TABLE Education
(
 EducationId serial NOT NULL,
 ResumeId    int NOT NULL,
 StartDate   json NOT NULL,
 EndDate     json NOT NULL,
 Institute   varchar(50) NOT NULL,
 Description varchar(60) NOT NULL,
 CONSTRAINT PK_10 PRIMARY KEY ( EducationId, ResumeId ),
 CONSTRAINT FK_9 FOREIGN KEY ( ResumeId ) REFERENCES Resume ( ResumeId )
);

CREATE INDEX FK_203 ON Education
(
 ResumeId
);


-- ************************************** Invitation

CREATE TABLE Invitation
(
 InvitationId serial NOT NULL,
 Title        varchar(50) NOT NULL,
 Email        varchar(50) NOT NULL,
 Status       varchar(50) NOT NULL,
 Description  varchar(60) NOT NULL,
 CONSTRAINT PK_11 PRIMARY KEY ( InvitationId )
);


-- ************************************** Invite

CREATE TABLE Invite
(
 InviteId     serial NOT NULL,
 InvitationId int NOT NULL,
 UserId       int NOT NULL,
 CONSTRAINT PK_12 PRIMARY KEY ( InviteId ),
 CONSTRAINT FK_17 FOREIGN KEY ( InvitationId ) REFERENCES Invitation ( InvitationId ),
 CONSTRAINT FK_19 FOREIGN KEY ( UserId ) REFERENCES "User" ( UserId )
);

CREATE INDEX FK_204 ON Invite
(
 InvitationId
);

CREATE INDEX FK_304 ON Invite
(
 UserId
);


-- ************************************** "Log"

CREATE TABLE "Log"
(
 LogId       uuid NOT NULL,
 Description varchar(50) NOT NULL,
 CONSTRAINT PK_13 PRIMARY KEY ( LogId )
);


-- ************************************** Observe

CREATE TABLE Observe
(
 ObservId  serial NOT NULL,
 LogId     uuid NOT NULL,
 AdminId_1 serial NOT NULL,
 CONSTRAINT PK_14 PRIMARY KEY ( ObservId ),
 CONSTRAINT FK_1 FOREIGN KEY ( AdminId_1 ) REFERENCES Admin ( AdminId ),
 CONSTRAINT FK_2 FOREIGN KEY ( LogId ) REFERENCES "Log" ( LogId )
);

CREATE INDEX FK_216 ON Observe
(
 AdminId_1
);

CREATE INDEX FK_305 ON Observe
(
 LogId
);


-- ************************************** Profile

CREATE TABLE Profile
(
 ProfileId    serial NOT NULL,
 FullName     varchar(50) NOT NULL,
 UserId       int NOT NULL,
 Email        json NOT NULL,
 Phone        json NOT NULL,
 RegistryDate timestamp NOT NULL,
 CONSTRAINT PK_15 PRIMARY KEY ( ProfileId ),
 CONSTRAINT FK_312 FOREIGN KEY ( UserId ) REFERENCES "User" ( UserId )
);

CREATE INDEX FK_205 ON Profile
(
 UserId
);


-- ************************************** Project

CREATE TABLE Project
(
 ProjectId   serial NOT NULL,
 Title       varchar(50) NOT NULL,
 Priority    varchar(50) NOT NULL,
 Price       decimal(12,2) NOT NULL,
 Deadline    json NOT NULL,
 Status      varchar(50) NOT NULL,
 Description varchar(60) NOT NULL,
 CONSTRAINT PK_16 PRIMARY KEY ( ProjectId )
);


-- ************************************** DefineProject

CREATE TABLE DefineProject
(
 DId       serial NOT NULL,
 "Date"      json NOT NULL,
 ProjectId int NOT NULL,
 UserId    int NOT NULL,
 CONSTRAINT PK_9 PRIMARY KEY ( DId ),
 CONSTRAINT FK_11 FOREIGN KEY ( UserId ) REFERENCES Employer ( UserId ),
 CONSTRAINT FK_12 FOREIGN KEY ( ProjectId ) REFERENCES Project ( ProjectId )
);

CREATE INDEX FK_202 ON DefineProject
(
 UserId
);

CREATE INDEX FK_303 ON DefineProject
(
 ProjectId
);


-- ************************************** Request

CREATE TABLE Request
(
 RequestId uuid NOT NULL,
 UserId    int NOT NULL,
 ProjectId int NOT NULL,
 "Date"      json NOT NULL,
 Status    varchar(50) NOT NULL,
 CONSTRAINT PK_17 PRIMARY KEY ( RequestId ),
 CONSTRAINT FK_13 FOREIGN KEY ( UserId ) REFERENCES Freelancer ( UserId ),
 CONSTRAINT FK_14 FOREIGN KEY ( ProjectId ) REFERENCES Project ( ProjectId )
);

CREATE INDEX FK_206 ON Request
(
 UserId
);

CREATE INDEX FK_306 ON Request
(
 ProjectId
);


-- ************************************** AcceptedProject

CREATE TABLE AcceptedProject
(
 AccpetedId serial NOT NULL,
 "Date"       json NOT NULL,
 UserId     int NOT NULL,
 RequestId  uuid NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( AccpetedId ),
 CONSTRAINT FK_25_1 FOREIGN KEY ( RequestId ) REFERENCES Request ( RequestId ),
 CONSTRAINT FK_26_1 FOREIGN KEY ( UserId ) REFERENCES Employer ( UserId )
);

CREATE INDEX FK_207 ON AcceptedProject
(
 RequestId
);

CREATE INDEX FK_307 ON AcceptedProject
(
 UserId
);


-- ************************************** Samples

CREATE TABLE Samples
(
 SampleId    serial NOT NULL,
 UserId      int NOT NULL,
 Title       varchar(50) NOT NULL,
 Image       varchar(50) NOT NULL,
 Description varchar(60) NOT NULL,
 CONSTRAINT PK_19 PRIMARY KEY ( SampleId, UserId ),
 CONSTRAINT FK_20 FOREIGN KEY ( UserId ) REFERENCES Freelancer ( UserId )
);

CREATE INDEX FK_209 ON Samples
(
 UserId
);


-- ************************************** Skill

CREATE TABLE Skill
(
 SkillId  serial NOT NULL,
 ResumeId int NOT NULL,
 Tilte    varchar(50) NOT NULL,
 Rating   integer NOT NULL,
 CONSTRAINT PK_20 PRIMARY KEY ( SkillId, ResumeId ),
 CONSTRAINT FK_10 FOREIGN KEY ( ResumeId ) REFERENCES Resume ( ResumeId )
);

CREATE INDEX FK_210 ON Skill
(
 ResumeId
);


-- ************************************** NeededSkills

CREATE TABLE NeededSkills
(
 NsId       serial NOT NULL,
 SkillId   serial NOT NULL,
 ProjectId int NOT NULL,
 ResumeId  int NOT NULL,
 CONSTRAINT PK_21 PRIMARY KEY ( NsId ),
 CONSTRAINT FK_25 FOREIGN KEY ( SkillId, ResumeId ) REFERENCES Skill ( SkillId, ResumeId ),
 CONSTRAINT FK_26 FOREIGN KEY ( ProjectId ) REFERENCES Project ( ProjectId )
);

CREATE INDEX FK_211 ON NeededSkills
(
 SkillId,
 ResumeId
);

CREATE INDEX FK_308 ON NeededSkills
(
 ProjectId
);


-- ************************************** TransactionHistory

CREATE TABLE TransactionHistory
(
 TransactionId serial NOT NULL,
 Amount        decimal(12,2) NOT NULL,
 "Date"          json NOT NULL,
 Type          varchar(50) NOT NULL,
 Status        varchar(50) NOT NULL,
 CONSTRAINT PK_22 PRIMARY KEY ( TransactionId )
);


-- ************************************** FinancialReport

CREATE TABLE FinancialReport
(
 ReportId      serial NOT NULL,
 UserId        int NOT NULL,
 TransactionId serial NOT NULL,
 CONSTRAINT PK_23 PRIMARY KEY ( ReportId ),
 CONSTRAINT FK_23 FOREIGN KEY ( UserId ) REFERENCES "User" ( UserId ),
 CONSTRAINT FK_24 FOREIGN KEY ( TransactionId ) REFERENCES TransactionHistory ( TransactionId )
);

CREATE INDEX FK_212 ON FinancialReport
(
 UserId
);

CREATE INDEX FK_309 ON FinancialReport
(
 TransactionId
);


-- ************************************** Work

CREATE TABLE Work
(
 WorkId      serial NOT NULL,
 ResumeId    int NOT NULL,
 StartDate   json NOT NULL,
 EndDate     json NOT NULL,
 Company     varchar(50) NOT NULL,
 Description varchar(60) NOT NULL,
 CONSTRAINT PK_24 PRIMARY KEY ( WorkId, ResumeId ),
 CONSTRAINT FK_8 FOREIGN KEY ( ResumeId ) REFERENCES Resume ( ResumeId )
);

CREATE INDEX FK_213 ON Work
(
 ResumeId
);


-- ************************************** WorksIn

CREATE TABLE WorksIn
(
 WorksInId serial NOT NULL,
 StartDate json NOT NULL,
 UserId    int NOT NULL,
 ProjectId int NOT NULL,
 EndDate   json NOT NULL,
 Status    varchar(50) NOT NULL,
 CONSTRAINT PK_25 PRIMARY KEY ( WorksInId ),
 CONSTRAINT FK_27 FOREIGN KEY ( ProjectId ) REFERENCES Project ( ProjectId ),
 CONSTRAINT FK_28 FOREIGN KEY ( UserId ) REFERENCES Freelancer ( UserId )
);

CREATE INDEX FK_214 ON WorksIn
(
 ProjectId
);

CREATE INDEX FK_310 ON WorksIn
(
 UserId
);

