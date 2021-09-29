/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as jsend from "../jsend";
import * as todos from "./todo_repository";

export async function getTODOs(
    uid: string,
    res: functions.Response) {
    try {
        const items = await todos.getUserTODOs(uid);
        functions.logger.log(items);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse(items));
    } catch (e) {
        functions.logger.log(e);
        res.status(500).send(jsend.error);
    }
}

export async function addTODO(
    uid: string,
    todo: any,
    res: functions.Response) {
    try {
        const item = await todos.insert(uid, todo);
        functions.logger.log(item);
        res.setHeader('Content-Type', 'application/json');
        res.status(201).send(jsend.successfullResponse({ "message": "Todo Created" }));
    } catch (e) {
        functions.logger.log(e);
        res.status(500).send(jsend.error);
    }
}

export async function updateTODO(
    uid: string,
    id: string,
    todo: string,
    res: functions.Response) {
    try {
        const item = todos.update(uid, id, todo);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse(item));
    } catch (e) {
        functions.logger.log(e);
        if (e instanceof todos.TODONotFoundError)
            res.status(404).send(jsend.error("TODO item not found"));
        else if (e instanceof todos.AccessForbidenError)
            res.status(403).send(jsend.error("Forbiden"));
        else res.status(500).send(jsend.error);
    }
}

export async function deleteTODO(
    uid: string,
    id: string,
    res: functions.Response) {
    try {
        todos.deleteItem(uid, id);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse({ "message": "Item deleted" }));
    } catch (e) {
        functions.logger.log(e);
        if (e instanceof todos.TODONotFoundError)
            res.status(404).send(jsend.error("TODO item not found"));
        else if (e instanceof todos.AccessForbidenError)
            res.status(403).send(jsend.error("Forbiden"));
        else res.status(500).send(jsend.error);
    }
}