import os
import shutil
import tarfile


def make_backup(source_dir, output_filename):
    with tarfile.open(output_filename, 'w:bz2') as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))


def oldest_file_in_folder(folder, extension=".bz2"):
    return min(
        (os.path.join(dirname, filename)
         for dirname, dirnames, filenames in os.walk(folder)
         for filename in filenames
         if filename.endswith(extension)),
        key=lambda fn: os.stat(fn).st_mtime)


def count_files_in_folder(folder, extension=".bz2"):
    count = 0
    for name in os.listdir(folder):
        path = os.path.join(folder, name)
        if os.path.isfile(path) and path.endswith(extension):
            count += 1
    return count


def copy_backup(source, destination, backup_count=5):
    if not os.path.exists(destination):
        os.mkdir(destination)
    shutil.copy2(source, destination)
    if count_files_in_folder(destination) > backup_count:
        os.remove(oldest_file_in_folder(destination))
