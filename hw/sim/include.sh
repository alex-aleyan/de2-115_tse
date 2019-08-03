
function does_file_exist() {
  fil="$1"
  if [ -f "$fil" ]; then 
    echo File exists: $fil
  else 
    echo -e "\nFile missing: $fil\n"; return -1 
  fi
  return 0
}


function does_dir_exist() {
  dir="$1"
  if [ -d "$dir" ]; then 
    echo Directory exists: $dir
  else 
    echo -e "\nDirectory missing: $dir\n"; return -1 
  fi
  return 0
}


function is_exec_in_path() {
  exec_file="$1"
  echo Executable is found: "$(which $exec_file ;if [ $? -ne 0 ]; then echo -e "\nCANNOT FIND $exec_file executable\n"; fi)"
}  

