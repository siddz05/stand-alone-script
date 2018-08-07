import os,subprocess,shutil,sys,time,traceback
from pathlib import Path

def get_home():
    return str(Path.home())+"/"

def run_command(cmd, shell=True):
    print("Firing Command --> " + str(cmd))
    result = subprocess.run(cmd, stdout=subprocess.PIPE, shell=shell)
    output = result.stdout.decode('utf-8')
    return output

def main(argv):
    '''Main Method To Download And Setup ELK Dump'''
    t1 = time.time()
    try:
        #Variables Decl..
        dump_name = argv[0]
        bucket_name="walmart-stream-storage-beta"
        bucket_abs_path = "/walmart-stream-storage-beta/elk-logs/"
        home_path=get_home()
        local_path = "elk-backup/"
        abs_local_path=home_path+local_path
        elk_location = "/var/lib/elasticsearch/elasticsearch"
        elk="elasticsearch"
        space= " "
        run_command("sudo service elasticsearch stop")
        download_command = "sudo gsutil cp gs:/"+bucket_abs_path+dump_name+space+abs_local_path+dump_name
        #Take the argument
        print ('Number of arguments:', len(argv), 'arguments.')
        print ('Argument List:', str(argv))
        print(dump_name)
        #initial Checks in the Script
        if not str(dump_name).endswith(".tar.gz"):
            print("Invalid Dump Name!! It should be <elk_dump.tar.gz>")
            sys.exit(2)
        else:
            #Good To Go
            #Delete The Pre Processed ELk Data From elk-backup and /var/log/elk
            #Step 1 -- download the elk
            print("cmd -- "+str(download_command))
            run_command(download_command)
            #Step 2 -- untar the elk folder
            cd_base_command = "cd "+abs_local_path
            run_command(cd_base_command)
            untar_command = "sudo tar -xvzf "+abs_local_path+dump_name
            run_command(untar_command)
            #Step 2 -- Delete the elk base dir
            delte_elk_base = "sudo rm -rf"+space+elk_location
            run_command(delte_elk_base)
            #Move The ELK dump from base_dir to var lib
            move_dump ="sudo mv"+space+home_path+elk+space+"/var/lib/elasticsearch/"
            run_command(move_dump)
            #Change permission of the elk which is inside the /varlog
            permission_change_cmd = "sudo chown"+space+elk+":"+elk+space+elk_location
            run_command(cmd=permission_change_cmd)
            #Restart Elasticsearch..
            run_command("sudo service elasticsearch restart")
            # run_command("sudo service kibana restart")
            #remove all folders inside elk-backup
            clear_elk_backup="sudo rm -rf"+space+abs_local_path+"*"
            #run_command(clear_elk_backup)
    except Exception as e:
        traceback.print_exc
        print(str(e))

if __name__ == "__main__":
  if len(sys.argv) != 2:
    print("Invalid Argument")
    print("python main.py <elk_dump.tar.gz>")
    sys.exit(2)
  main(sys.argv[1:])
