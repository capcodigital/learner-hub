export function successfullResponse(values?: any) {
    const json = {
        status: "success",
        "data": values
    };
    return JSON.stringify(json);
}

export function error(msg: string = "Internal Server Error") {
    const json = {
        status: "error",
        "error": msg
    };
    return JSON.stringify(json);
}