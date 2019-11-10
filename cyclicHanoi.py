def printStep(fromStake, wise, indent):
    print(indent*'  ' + wise + ' - Move a ring from stake '+ str(fromStake))

def clock (n, fromS, toS, auxS, indent):
    if n > 0:
        global step
        thisStep = step
        print(indent*'  ' + '-'+ str(thisStep) +'--START-C--- Moving ' + str(n) + ' disks from ' + str(fromS) + ' to ' + str(toS))
        step = step + 1
        anti(n-1, fromS, auxS, toS, indent + 2)
        printStep(fromS, 'C', indent + 2)
        anti(n-1, auxS, toS, fromS, indent + 2)
        print(indent*'  ' + '-'+ str(thisStep) +'--END-C-' + str(n) + '-'+ str(fromS)+'-'+ str(toS)+'-'+ str(auxS)+'-------------------------')

def anti (n, fromS, toS, auxS, indent):
    if n > 0:
        global step
        thisStep = step
        print(indent*'  ' + '-'+ str(thisStep) +'--START-A--- Moving ' + str(n) + ' disks from ' + str(fromS) + ' to ' + str(toS))
        step = step + 1
        anti(n-1, fromS, toS, auxS, indent + 2)
        printStep(fromS, 'C', indent + 2)
        clock(n-1, toS, fromS, auxS, indent + 2)
        printStep(auxS, 'C', indent + 2)
        anti(n-1, fromS, toS, auxS, indent + 2)
        print(indent*'  ' + '-'+ str(thisStep) +'--END-C-' + str(n) + '-'+ str(fromS)+'-'+ str(toS)+'-'+ str(auxS)+'-------------------------')

n = int(input('Enter the number of disks: '))
fromStake = int(input('Enter the FROM stake: '))
toStake = int(input('Enter the TO stake: '))
step = 0

aux = 1
if fromStake == 1:
    if toStake == 2:
        aux = 3
    else:
        aux = 2
elif fromStake == 2:
    if toStake == 1:
        aux = 3
elif fromStake == 3:
    if toStake == 1:
        aux = 2

clock(n, fromStake, toStake, aux, 0)