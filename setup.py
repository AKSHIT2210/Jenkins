# Copyright 2022 Choice Hotels International
import os
import unittest
from os.path import dirname

from setuptools import setup, find_packages

my_dir = dirname(__file__)


def test_suite():
    """Test suite for discovery of automated tests"""
    test_loader = unittest.TestLoader()
    test_suite = test_loader.discover(
        os.path.join(my_dir, 'tests'), pattern='test_*.py')
    return test_suite


setup(
    name="lambda",
    test_suite='setup.test_suite',
    packages=find_packages()
)
