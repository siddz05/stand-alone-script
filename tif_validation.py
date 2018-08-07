import sys, pandas as pd, traceback, re,time, json as j
import numpy as np
def main(argv):
  '''Main Method To Validate The Submission Files'''
  global msg
  global status
  final_out = {}
  t1 = time.time()
  try:
      #Take the argument
      sub_file,sub_format_file,sol_file = argv
      #print ('Number of arguments:', len(argv), 'arguments.')
      #print ('Argument List:', str(argv))
      #initial Checks in the Script
      result = False
      status = "SUCCESS"
      msg = "All Good, To Go!"
      #Read both the CSV Files.
      d_sub = pd.read_csv(sub_file)
      d_sub_format = pd.read_csv(sub_format_file)
      d_sol = pd.read_csv(sol_file)
      #Do the First Test -- Both CSV Length Should Be Same.
      result = compare_list(list1=list(d_sub), list2=list(d_sub_format))
      if result is False:
            status = "ERROR"
            msg = "The submitted file has incorrect format (naming of csv headers or roi/year/month). Please check submission format & resubmit."
      if result:
        #If, the result is True, Create a Colum cax_id_data for further Checks -- both CSVs
        d_sub['cax_id_data'] = d_sub["cax_id"].map(str) + d_sub["roi_id"].map(str) + d_sub["year"].map(str) + d_sub[
            "month"].map(str)
        #Convert the value to List
        sub_list = d_sub['cax_id_data'].tolist()
        # -- do --
        d_sub_format['cax_id_data'] = d_sub_format["cax_id"].map(str) + d_sub_format["roi_id"].map(str) + \
                                    d_sub_format["year"].map(str) + d_sub_format["month"].map(str)
        sub_format_list = d_sub_format['cax_id_data'].tolist()
        #2nd Check -- if, the cax_id_data List is exact match or not.
        result = compare_list(list1=sub_list, list2=sub_format_list)
        if result is False:
            msg = "The submitted file has incorrect format (please check #rows, #columns, mismatch in order or its values of rows or columns). Please check submission format & resubmit."
            status = "ERROR"
      if result:
        #If True, -- Fix The Prediction Column.
        d_sub_list = d_sub['prediction'].str[1:-1].tolist()
        d_sol_list = d_sol['actuals'].str[1:-1].tolist()
        #Send it to Validate List
        result = validate_list(d_sol_list=d_sol_list,d_sub_list=d_sub_list)
      final_out.update({'status': status, 'message': result,'data':msg,'time':str(round(time.time()-t1,2))+" sec"})
      print(j.dumps(final_out))
  except Exception as e:
      final_out.update({'status': 'ERROR', 'data': 'Error in file format','time':str(round(time.time()-t1,2))+" sec"})
      print(j.dumps(final_out))

#Defs Below, this line.
def validate_list(d_sol_list,d_sub_list):
  global msg
  global status
  i = 0
  #print(d_sub_list)
  for val1 in d_sub_list:
    val2=d_sol_list[i]
    i +=1
    if val1 is np.nan:
        msg = "The Prediction value contains NA, At Row: "+str(i)+" Please check submission format & resubmit. "
        status = "ERROR"
        return False 
    if len(val2.split(',')) != len(val1.split(',')):
        msg = "The prediction array length is incorrect, At Row: "+str(i)+" Please check submission format & resubmit. "
        status = "ERROR"
        return False   
    else:
        res_list = re.findall(r'([a-zA-Z\-\.\\\<\>\/\;\:\"\'\}\{\?\(\)\_\+\=\!\@\#\$\%\^\&\*\~\`\[\]])|\,\,|(?<!\d)\,|\,(?!\d)', val1.replace(" ", ""),
                              flags=re.I)
        if len(res_list) > 0:
            msg = "The prediction array format is incorrect, Found: ["+ str(res_list)[1:20]+"] At Row: "+str(i)+" Please enter only label prediction. Please check submission format & resubmit.!"
            status = "ERROR"
            return False
  return True


def compare_list(list1, list2):
    return list1 == list2


if __name__ == "__main__":
  if len(sys.argv) != 4:
    print("Invalid Argument")
    print("python main.py <sub_file.csv> <sub_file_format.csv> <sol_file.csv>")
    sys.exit(2)
  main(sys.argv[1:])
