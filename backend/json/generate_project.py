import json
from datetime import datetime

projects_data = """1	"11AX"	true
2	"ATTILA"	true
3	"BARCA"	true
4	"F3896"	true
5	"Callix"	true
6	"F5290v2"	true
7	"F5295"	true
8	"F5297"	true
9	"F5380"	true
10	"F5681"	true
11	"F5685 MV3"	true
12	"F5688"	true
13	"F5688 EOLE v2"	true
14	"F5688 TMO"	true
15	"HH4K6E"	true
16	"HH5K"	true
17	"SUPERPOD"	true
18	"CGA4131"	true
19	"CGA4332"	true
20	"DGA4135"	true
21	"DGM4137"	true
22	"DGM4980"	true
23	"DNA0332"	true
24	"DWA4135"	true
25	"FGA2130"	true
26	"MGA5331"	true
27	"OWA813"	true
28	"XB8"	true
29	"PD160"	true
30	"M6"	true
31	"M7"	true
32	"RAX30"	true
33	"RAXE300"	true
34	"M3"	true
35	"F3897T"	true
36	"Others"	true"""

# Convert to list of dictionaries
fixtures = []
for line in projects_data.split('\n'):
    id, name, is_enabled = line.split('\t')
    fixtures.append({
        "model": "api.project",
        "pk": int(id),
        "fields": {
            "name": name.strip('"'),
            "is_enabled": is_enabled.lower() == 'true',
            "created_at": "2024-01-01T00:00:00Z",
            "updated_at": "2024-01-01T00:00:00Z"
        }
    })

# Save as JSON file
with open('projects.json', 'w') as f:
    json.dump(fixtures, f, indent=4)