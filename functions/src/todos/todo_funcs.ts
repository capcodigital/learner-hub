/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as jsend from "../jsend";
import * as todoRepo from "./todo_repository";
import * as userRepo from "../users/users_repository";

export async function getTODOs(
    uid: string,
    res: functions.Response) {
    try {
        userRepo.getUser(uid); // will throw UserNotFoundError if uid not exist
        const items = await todoRepo.getUserTODOs(uid);
        functions.logger.log(items);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse(items));
    } catch (e) {
        functions.logger.log(e);
        if (e instanceof userRepo.UserNotFoundError)
            res.status(400).send(jsend.error("Bad Request"));
        else res.status(500).send(jsend.error);
    }
}

export async function addTODO(
    todo: TODO,
    res: functions.Response) {
    try {
        userRepo.getUser(todo.userId);
        const item = await todoRepo.insert(todo);
        functions.logger.log(item);
        res.setHeader('Content-Type', 'application/json');
        res.status(201).send(jsend.successfullResponse(item));
    } catch (e) {
        functions.logger.log(e);
        if (e instanceof userRepo.UserNotFoundError)
            res.status(400).send(jsend.error("Bad Request"));
        else res.status(500).send(jsend.error);
    }
}

export async function updateTODO(
    uid: string,
    todoId: string,
    todo: any,
    res: functions.Response) {
    try {
        const item = todoRepo.update(uid, todoId, todo);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse(item));
    } catch (e) {
        functions.logger.log(e);
        if (e instanceof todoRepo.TODONotFoundError)
            res.status(404).send(jsend.error("TODO item not found"));
        else if (e instanceof todoRepo.AccessForbidenError)
            res.status(403).send(jsend.error("Forbiden"));
        else res.status(500).send(jsend.error);
    }
}

export async function deleteTODO(
    uid: string,
    todoId: string,
    res: functions.Response) {
    try {
        todoRepo.deleteItem(uid, todoId);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse({ "message": "Item deleted" }));
    } catch (e) {
        functions.logger.log(e);
        if (e instanceof todoRepo.TODONotFoundError)
            res.status(404).send(jsend.error("TODO item not found"));
        else if (e instanceof todoRepo.AccessForbidenError)
            res.status(403).send(jsend.error("Forbiden"));
        else res.status(500).send(jsend.error);
    }
}