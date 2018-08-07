"""
Created on Sun 22 April 2018 01:05 AM
@author: pramath kumar mishra
@email: pramath@crowdanalytix.com

Output schema validator for wmt-stream project
"""

import json
def schema_validator(model, model_name):

    def wrapper():
        result = model()
        resultX = json.loads(result)
        flag = 1
        if isinstance(resultX["prediction"], list) and isinstance(resultX["probability"], list):
            if isinstance(resultX["status"], str) and isinstance(resultX["attribute"], str):
                if resultX["status"] == "OK" and len(resultX["prediction"]) == len(resultX["probability"]):
                    if resultX["prediction"]:
                        if sum([0 if isinstance(x, str) else 1 for x in resultX["prediction"]]):
                            flag = 0
                        else:
                            pass
                    if resultX["probability"]:
                        if sum([0 if isinstance(x, int) else 1 for x in resultX["probability"]]):
                            flag = 0
                        else:
                            pass
                    if resultX["attribute"] != model_name:
                        flag = 0
                    else:
                        pass
                else:
                    flag = 0
            else:
                flag = 0
        else:
            flag = 0


        if flag:
            return result
        else:
            return json.dumps(
                {
                    "status": "OK",
                    "attribute": model_name,
                    "prediction": [],
                    "probability": []
                }
            )                

    return wrapper
