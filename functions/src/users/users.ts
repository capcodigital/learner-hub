/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions";
import {
    insertUser,
    editUser,
    getAllUsers
} from "../firestore_funs";

// // TO REMOVE
// export async function postUser(
//     url: string,
//     props: any,
//     res: functions.Response) {
//     const fullUrl = url;
//     const user = {
//         id: props['id'],
//         email: props['email'],
//         passwordHash: props['passwordHash'],
//         firstName: props['firstName'],
//         surname: props['surname'],
//         jobTitle: props['jobTitle'],
//         bio: props['bio'],
//         confluenceConnected: props['confluenceConnected'],
//     };
//     await axios.default.post(fullUrl,
//         { user: user })
//         .then(function (response) {
//             res.statusCode = 200;
//             res.send(response.data);
//         }).catch((e) => {
//             logger.log(e);
//             res.statusCode = 500;
//             res.send("error");
//         });
// }

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
            res.send("error");
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
        res.statusCode = 500;
        res.send(JSON.stringify(e));
    }
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
        res.statusCode = 500;
        res.send(JSON.stringify(e));
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
        res.send(JSON.stringify("error"));
    }
}