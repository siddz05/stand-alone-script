import sys,tarfile,random,string
program_name = sys.argv[0]
file_path = sys.argv[1]
tar_file_name=''.join(random.choices(string.ascii_uppercase + string.digits, k=4))
print("FilePath :"+str(file_path))
print("Starting Taring..")
with tarfile.open(str(tar_file_name) + '_py.tar.gz', mode='w:gz') as archive:
    archive.add(file_path, recursive=True)
print("Finished: "+str(tar_file_name))
