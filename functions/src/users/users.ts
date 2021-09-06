/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions";
// import * as admin from 'firebase-admin';
import { getAllUsers } from "../firestore_funs";

// interface UserParam {
//     [key: string]: string | number;
// }

// var obj: UserParam = {
//     key1: "apple",
//     key3: 123
// };

export async function addUser(
    url: string,
    userId: string,
    props: any,
    res: functions.Response) {
    const fullUrl = url + "?id=" + userId;
    await axios.default.put(fullUrl,
        { properties: props })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(resp.data);
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send("error");
        });
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

export async function updateUser(
    url: string,
    userId: string,
    props: any,
    res: functions.Response) {
    const fullUrl = url + "?id=" + userId;
    await axios.default.put(fullUrl,
        { properties: props })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(resp.data);
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send("error");
        });
}