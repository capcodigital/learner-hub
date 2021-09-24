/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as jsend from "../jsend";
import * as userCertRepo from "./user_certifications_repository";

export async function addUserCertification(
    uid: string,
    userCert: any,
    res: functions.Response) {
    try {
        const item = await userCertRepo.insert(uid, userCert);
        functions.logger.log(item);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 201;
        res.send(jsend.successWithData(item));
    } catch (e) {
        functions.logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

export async function getUserCertifications(
    uid: string,
    res: functions.Response) {
    try {
        const item = await userCertRepo.insert(uid, userCert);
        functions.logger.log(item);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 201;
        res.send(jsend.successWithData(item));
    } catch (e) {
        functions.logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

export async function updateUserCertification(
    id: string,
    cert: string,
    res: functions.Response) {
    try {
        userCertRepo.update(id, cert);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 201;
        res.send(jsend.success);
    } catch (e) {
        functions.logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

export async function deleteUserCertification(
    id: string,
    res: functions.Response) {
    try {
        userCertRepo.deleteItem(id);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 201;
        res.send(jsend.success);
    } catch (e) {
        functions.logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

