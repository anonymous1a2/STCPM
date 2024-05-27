import math
import os
import sys


Gaston_S_SBOX = [0,5,10,11,20,17,22,23,9,12,3,2,13,8,15,14,18,21,24,27,6,1,4,7,26,29,16,19,30,25,28,31]
SBD_SBOX = [6,15,4,14,5,13,21,29,10,11,12,8,0,9,20,24,2,19,7,31,3,1,23,25,26,27,30,28,18,17,22,16]

linear_sam = open("linear_sample",'r')
diff_sam = open("diff_sample",'r')
lines_linear_sam = linear_sam.readlines()
lines_diff_sam = diff_sam.readlines()


def search_diff(truth,name,theta):
    write = open(f"{name}/diff.mzn", 'w')

    for aline in lines_diff_sam:
        write.write(aline)
    pairs = [0]*pow(2,10)
    for input in range(0,32):
        for diff_in in range(0,32):
            out1 = truth[input]
            out2 = truth[diff_in^input]
            diff_out = out1 ^ out2
            index = (diff_in << 5) | diff_out
            pairs[index] = pairs[index] + 1

    leng = 0
    len3 = 0
    len4 = 0
    len2 = 0
    len1 = 0
    len241 = 0
    lenother = 0
    for i in range(0, 1024):
        pairs[i] = abs(pairs[i])
        if pairs[i] != 0:
            pairs[i] = int(100*math.log2(32 / pairs[i]))
            leng = leng + 1
            if pairs[i] == 100:
                len1 = len1 + 1
            elif pairs[i] == 241:
                len241 = len241 + 1
            elif pairs[i] == 200:
                len2 = len2 + 1
            elif pairs[i] == 300:
                len3 = len3 + 1
            elif pairs[i] == 400:
                len4 = len4 + 1
            else:
                lenother = pairs[i]
    write.write("\n")
    write.write(f"array [1..{leng}, 1..11] of int : DDT = array2d(1..{leng},1..11,[")
    write.write("0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0")
    for i in range(1, 32):
        for j in range(0,32):
            if pairs[i << 5 | j] != 0:
                write.write(", ")
                for k in range(0,5):
                    write.write(str((i >> (4-k))&0x1) + ', ')
                for k in range(0,5):
                    write.write(str((j >> (4-k))&0x1) + ', ')
                write.write(str(pairs[i<<5|j]))
    write.write("]);\n")
    write.close()
    os.system(f'sh diff.sh {name} {theta}')






def search_linear(truth,name,theta):
    os.system(f'mkdir {name}')
    write = open(f"{name}/linear.mzn", 'w')
    for aline in lines_linear_sam:
        write.write(aline)

    pairs = [0] * pow(2, 10)
    for mask_in in range(0, 32):
        for mask_out in range(0, 32):
            for plain_in in range(0, 32):
                plain_out = truth[plain_in]

                in_after_mask = plain_in & mask_in

                in_dot_sum = 0
                for num_i in range(0, 32):
                    if (in_after_mask >> num_i) & 0x1 == 1:
                        in_dot_sum = in_dot_sum + 1

                out_after_mask = plain_out & mask_out

                out_dot_sum = 0
                for num_i in range(0, 32):
                    if (out_after_mask >> num_i) & 0x1 == 1:
                        out_dot_sum = out_dot_sum + 1

                in_dot_sum = in_dot_sum % 2
                out_dot_sum = out_dot_sum % 2

                index = (mask_out << 5) | mask_in

                if in_dot_sum == out_dot_sum:
                    pairs[index] = pairs[index] + 1

    leng = 0
    len3 = 0
    len4 = 0
    len2 = 0
    len1 = 0
    len241 = 0
    lenother = 0
    for i in range(0, 1024):
        pairs[i] = pairs[i] - 16
        pairs[i] = abs(pairs[i])
        if pairs[i] != 0:
            pairs[i] = int(100*math.log2(32 / pairs[i]))
            leng = leng + 1
            if pairs[i] == 100:
                len1 = len1 + 1
            elif pairs[i] == 241:
                len241 = len241 + 1
            elif pairs[i] == 200:
                len2 = len2 + 1
            elif pairs[i] == 300:
                len3 = len3 + 1
            elif pairs[i] == 400:
                len4 = len4 + 1
            else:
                lenother = pairs[i]

    write.write("\n")
    write.write(f"array [1..{leng}, 1..11] of int : DDT = array2d(1..{leng},1..11,[")
    write.write("0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0")
    for i in range(1, 32):
        for j in range(0, 32):
            if pairs[i << 5 | j] != 0:
                write.write(", ")
                for k in range(0, 5):
                    write.write(str((i >> (4 - k)) & 0x1) + ', ')
                for k in range(0, 5):
                    write.write(str((j >> (4 - k)) & 0x1) + ', ')
                write.write(str(pairs[i << 5 | j]))
    write.write("]);\n")
    write.close()
    os.system(f'sh linear.sh {name} {theta}')



if len(sys.argv) == 1:
    print("Missing parameter, one num is required, 1 means searching for tails of Gaston_S, 2 means searching for tails of SBD")
    sys.exit()

if int(sys.argv[1]) == 1:
    truth_num = Gaston_S_SBOX
    name = "Gaston_S"
    os.system(f'mkdir Gaston_S')
    all_theta=[6,6]
    for theta in all_theta:
        search_linear(truth_num,name,theta)
        search_diff(truth_num,name,theta)

elif int(sys.argv[1]) == 2:
    truth_num = SBD_SBOX
    name = "SBD"
    os.system(f'mkdir SBD')
    all_theta=[6,6]
    for theta in all_theta:
        search_linear(truth_num,name,theta)
        search_diff(truth_num,name,theta)


else:
    print("Error num, 1 means searching for tails of Gaston_S, 2 means searching for tails of SBD")

















