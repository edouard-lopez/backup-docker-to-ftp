import os
import shutil
import unittest

from backups.backup import make_backup, count_files_in_folder, copy_backup


class BackupTestCase(unittest.TestCase):
    def setUp(self):
        self.filename = 'test.tar.bz2'
        self.test_folder = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'tar')

    def test_create_backup(self):
        make_backup(self.test_folder, self.filename)
        self.assertTrue(os.path.exists(self.filename))

    def tearDown(self):
        if os.path.exists(self.filename):
            os.remove(self.filename)


class CopyTestCase(unittest.TestCase):
    def setUp(self):
        self.test_dir = os.path.dirname(os.path.realpath(__file__))
        self.test_folder = os.path.join(self.test_dir, 'tar')
        self.tmp_folder = os.path.join(self.test_dir, 'tmp')
        os.mkdir(self.tmp_folder)
        self.backups_name = ['test1.tar.bz2', 'test2.tar.bz2', 'test3.tar.bz2']

    def test_copy_backup(self):
        with open(self.backups_name[0], 'w') as f: pass
        copy_backup(os.path.join(self.test_dir, self.backups_name[0]), self.tmp_folder)
        self.assertTrue(os.path.exists(os.path.join(self.tmp_folder, self.backups_name[0])))

    def test_copy_file_and_keep_only_backup_count(self):
        older_file = os.path.join(self.tmp_folder, '1')
        with open(os.path.join(self.tmp_folder, '1.tar.bz2'), 'w') as f: pass
        with open(os.path.join(self.tmp_folder, '2.tar.bz2'), 'w') as f: pass
        with open(os.path.join(self.tmp_folder, '3.tar.bz2'), 'w') as f: pass

        filepath = os.path.join(self.test_dir, '4.tar.bz2')
        with open(filepath, 'w') as f: pass
        copy_backup(filepath, self.tmp_folder, backup_count=3)

        self.assertTrue(os.path.exists(filepath))
        self.assertFalse(os.path.exists(older_file))
        os.remove(filepath)

    def test_count_file_in_folder(self):
        self.assertEqual(0, count_files_in_folder(os.path.join(self.test_folder, 'a')))
        self.assertEqual(1, count_files_in_folder(os.path.join(self.test_folder, 'b')))
        self.assertEqual(2, count_files_in_folder(os.path.join(self.test_folder, 'a', 'a1')))

    def tearDown(self):
        for file in self.backups_name:
            if os.path.exists(file):
                os.remove(file)
        shutil.rmtree(self.tmp_folder)


if __name__ == '__main__':
    unittest.main()
