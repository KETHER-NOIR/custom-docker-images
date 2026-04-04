#!/usr/bin/env python3
import sys
from docutils.core import publish_parts

print(publish_parts(source=sys.stdin.read(), writer_name="html")["html_body"])
