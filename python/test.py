list1 = (('1. Store name: Cut\nAddress: 9500 Wilshire Blvd, Beverly Hills, CA 90212\nTelephone: +1 310-276-8500\n'
     'Recommended menu: Bone-in Rib Eye Steak, New York Sirloin Steak\nReason for recommendation: Located in the Beverly'
     ' Wilshire Four Seasons Hotel, CUT is a high-end steakhouse by celebrity chef Wolfgang Puck. '
     'It is famous for its delicious and top-quality steaks. The restaurant has been a strong favorite among')
     .replace("1.","")).split("\n")
final = {}
for item in list1:
    k, v = item.split(":")
    final[k] = v
print(final)
