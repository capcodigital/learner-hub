/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import { logger } from "firebase-functions";
import * as admin from 'firebase-admin';
import * as userRepo from "./users_repository";
import * as jsend from "../jsend";

// Creates user in firebase auth and adds them to firestore 
// Users collection
export async function registerUser(
    properties: any,
    res: functions.Response
) {
    const email = properties["email"] as string;
    const password = properties["password"] as string;
    const firstName = properties["firstName"] as string;
    const surname = properties["surname"] as string;
    const jobTitle = properties["jobTitle"] as string;
    const bio = properties["bio"] as string;
    // Add user in firebase auth
    admin.auth().createUser({
        email: email,
        emailVerified: false,
        password: password,
        displayName: firstName + " " + surname,
        disabled: false,
    }).then(function (record) {
        logger.log("User created:", record.uid);
        const skills: UserSkills = {
            primarySkills: [],
            secondarySkills: []
        }
        const user: User = {
            email: email,
            firstName: firstName,
            surname: surname,
            jobTitle: jobTitle,
            bio: bio,
            confluenceConnected: false,
            skills: skills
        }
        // Add user in firestore
        userRepo.insertUser(record.uid, user);
        res.statusCode = 200;
        res.send(jsend.success("User added successfully"));
    }).catch(function (e) {
        logger.log(e);
        res.statusCode = 409;
        res.send(jsend.error("User already exists"));
    });
}

// Updates user in firestore and returns a response
export async function updateUser(
    userId: string,
    property: any,
    res: functions.Response) {
    try {
        userRepo.editUser(userId, property);
        res.statusCode = 200;
        res.send(jsend.success("User updated successfully"));
    } catch (e) {
        logger.log(e);
        res.statusCode = 404;
        res.send(jsend.error("User does not exist", 404));
    }
}