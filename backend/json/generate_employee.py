import json
from datetime import datetime

employees_data = """1	"Apria Wati"	"MW2300234"	true
2	"Chris Easterjordan"	"MW2300225"	false
3	"Dennis Harnandi"	"MW2300285"	true
4	"Jeffry Jaman"	"MW2100721"	true
5	"Jeremy Christoputra"	"MW2202304"	true
6	"Laurence Hasan"	"MW2101784"	true
7	"Martin Vermilli"	"MW2201208"	true
8	"Michael Julianpete"	"MW2300226"	true
9	"Otniel Dwimarti"	"MW2202033"	true
10	"Tommy Pratama"	"MW2200166"	false
11	"Ivan Wijaya"	"MW2301584"	true
12	"Vincent Utama"	"MW2301652"	true
13	"Winnie1 Chuang"	"MW2301723"	true
14	"Jonathan Miharja"	"MW2400027"	true
15	"Muchammad Farel"	"MW2400310"	true
16	"Samuel Halomoan"	"MW2400549"	true
17	"Muhammad Arieb"	"MW2400895"	true
18	"Reynard Bastian"	"MW2401437"	true"""

# Convert to list of dictionaries
fixtures = []
for line in employees_data.split('\n'):
    id, name, emp_id, is_enabled = line.split('\t')
    fixtures.append({
        "model": "api.employee",
        "pk": int(id),
        "fields": {
            "name": name.strip('"'),
            "emp_id": emp_id.strip('"'),
            "is_enabled": is_enabled.lower() == 'true',
            "created_at": "2024-01-01T00:00:00Z",
            "updated_at": "2024-01-01T00:00:00Z"
        }
    })

# Save as JSON file
with open('employees.json', 'w') as f:
    json.dump(fixtures, f, indent=4)