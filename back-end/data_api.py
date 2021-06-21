from typing import Optional
from pull_clean import main as data
from fastapi import FastAPI, HTTPException
import pull_clean
from functools import wraps

app = FastAPI()

url_completed = "https://ilabs-capco.atlassian.net/wiki/rest/api/content/2122383393?expand=body.export_view.value"
url_in_progress = "https://ilabs-capco.atlassian.net/wiki/rest/api/content/1593770009?expand=body.export_view.value"


def check_pullclean_errors(original_func):
    @wraps(original_func)
    async def decorated(*args, **kwargs):
        try:
            return await original_func(*args, **kwargs)
        except (pull_clean.EnvFileMissingError, pull_clean.EnvVariablesError):
            raise HTTPException(
                status_code=500, detail='.env file missing or contains invalid data')
        except (pull_clean.ConfluencePageContentError, pull_clean.ConfluenceTableError):
            raise HTTPException(
                status_code=503, detail='requested data may have been moved or changed')
    return decorated


@app.get('/completed')
@check_pullclean_errors
def show_comp():
    return data(url_completed)


@app.get('/in_progress')
@check_pullclean_errors
def show_in_progress():
    return data(url_in_progress)


@app.get('/completed/platform={platform}')
@check_pullclean_errors
def show_plat_comp(platform: str):
    db_completed = data(url_completed)
    db = []
    for i in db_completed.keys():
        if platform.casefold() in db_completed[i]['Platform'].casefold().replace(' ', ''):
            db.append(db_completed[i])
    return db


@app.get('/in_progress/platform={platform}')
@check_pullclean_errors
def show_plat_in_progress(platform: str):
    db_in_progress = data(url_completed)
    db = []
    for i in db_in_progress.keys():
        if platform.casefold() in db_in_progress[i]['Platform'].casefold().replace(' ', ''):
            db.append(db_in_progress[i])
    return db


@app.get('/completed/name={employee}')
@check_pullclean_errors
def show_employee_comp(employee: str):
    db_completed = data(url_completed)
    db = []
    for x in db_completed.keys():
        if employee.casefold() in db_completed[x]['Name'].casefold().replace(' ', ''):
            db.append(db_completed[x])
    return db


@app.get('/in_progress/name={employee}')
@check_pullclean_errors
def show_employee_in_progress(employee: str):
    db_in_progress = data(url_in_progress)
    db = []
    for x in db_in_progress.keys():
        if employee.casefold() in db_in_progress[x]['Name'].casefold().replace(' ', ''):
            db.append(db_in_progress[x])
    return db


@app.get('/name={employee}')
@check_pullclean_errors
def show_employee(employee: str):
    db_completed = data(url_completed)
    db_in_progress = data(url_in_progress)
    db = []
    db_comp_2 = []
    db_in_prog_2 = []
    for x in db_completed.keys():
        if employee.casefold() in db_completed[x]['Name'].casefold().replace(' ', ''):
            db_comp_2.append(db_completed[x])
    db.append(db_comp_2)
    for x in db_in_progress.keys():
        if employee.casefold() in db_in_progress[x]['Name'].casefold().replace(' ', ''):
            db_in_prog_2.append(db_in_progress[x])
    db.append(db_in_prog_2)
    return db


@app.get('/platform={platform}')
@check_pullclean_errors
def show_platform(platform: str):
    db_completed = data(url_completed)
    db_in_progress = data(url_in_progress)
    db = []
    db_comp_2 = []
    db_in_prog_2 = []
    for x in db_completed.keys():
        if platform.casefold() in db_completed[x]['Platform'].casefold().replace(' ', ''):
            db_comp_2.append(db_completed[x])
    db.append(db_comp_2)
    for x in db_in_progress.keys():
        if platform.casefold() in db_in_progress[x]['Platform'].casefold().replace(' ', ''):
            db_in_prog_2.append(db_in_progress[x])
    db.append(db_in_prog_2)
    return db
