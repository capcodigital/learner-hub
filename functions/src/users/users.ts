/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions";
import * as admin from 'firebase-admin';
import {
    insertUser,
    editUser,
    getAllUsers
} from "./users_repository";

// Executes POST request to a url to signup a user.
// Takes a user properties array as argument
export async function postUser(
    url: string,
    properties: any,
    res: functions.Response) {
    await axios.default.post(url,
        { properties: properties })
        .then(function (response) {
            res.statusCode = 200;
            res.send(response.data);
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send(JSON.stringify("Error"));
        });
}

// PUT request to update-user endpoint
export async function putUser(
    url: string,
    userId: number,
    prop: any,
    res: functions.Response) {
    const fullUrl = url + "?id=" + userId;
    await axios.default.put(fullUrl,
        { property: prop })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(resp.data);
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send(JSON.stringify("Error"));
        });
}

// Adds user in firestore and returns a response
export async function addUser(
    user: User,
    res: functions.Response) {
    try {
        insertUser(user);
        res.statusCode = 200;
        res.send(JSON.stringify("success"));
    } catch (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(JSON.stringify("Error"));
    }
}

export async function signupUser(
    properties: any,
    res: functions.Response
) {
    const email = properties["email"] as string;
    const password = properties["password"] as string;
    const firstName = properties["firstName"] as string;
    const surname = properties["surname"] as string;
    const jobTitle = properties["jobTitle"] as string;
    const bio = properties["bio"] as string;

    admin.auth().createUser({
        email: email,
        emailVerified: false,
        password: password,
        displayName: firstName,
        disabled: false,
    }).then(function (userRecord) {
        logger.log("Successfully created new user:", userRecord.uid);
        const user: User = {
            id: userRecord.uid,
            email: email,
            password: password,
            passwordHash: "",
            firstName: firstName,
            surname: surname,
            jobTitle: jobTitle,
            bio: bio,
            confluenceConnected: false,
        }
        addUser(user, res);
    }).catch(function (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(JSON.stringify("Error creating user"));
    });
}

// Updates user in firestore and returns a response
export async function updateUser(
    id: number,
    property: any,
    res: functions.Response) {
    try {
        editUser(id, property);
        res.statusCode = 200;
        res.send(JSON.stringify("success"));
    } catch (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(JSON.stringify("Error updating user"));
    }
}

export async function getUsers(res: functions.Response) {
    try {
        const items = await getAllUsers();
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(JSON.stringify(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(JSON.stringify("Error getting all users"));
    }
}