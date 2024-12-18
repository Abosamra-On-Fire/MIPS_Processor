#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <vector>
#include <sstream>
#include <bitset>
#include <filesystem>
using namespace std;

unordered_map<string, string> opcodeMap = {
    {"NOP", "00000"},
    {"IADD", "01011"},
    {"RET", "10110"},
    {"HLT", "00001"},
    {"PUSH", "01100"},
    {"INT", "10111"},
    {"SETC", "00010"},
    {"POP", "01101"},
    {"RTI", "11000"},
    {"NOT", "00011"},
    {"LDM", "01110"},
    {"RESET", "11001"},
    {"INC", "00100"},
    {"LDD", "01111"},
    {"OUT", "00101"},
    {"STD", "10000"},
    {"IN", "00110"},
    {"JZ", "10001"},
    {"MOV", "00111"},
    {"JN", "10010"},
    {"ADD", "01000"},
    {"JC", "10011"},
    {"SUB", "01001"},
    {"JMP", "10100"},
    {"AND", "01010"},
    {"CALL", "10101"},
};
unordered_map<string, string> registerMap = {
    {"$t0", "000"},
    {"$t1", "001"},
    {"$t2", "010"},
    {"$t3", "011"},
    {"$t4", "100"},
    {"$t5", "101"},
    {"$t6", "110"},
    {"$t7", "111"}};

string bin(int number)
{
    bitset<16> binary(number);
    return binary.to_string();
}

string parseInstruction(const string &line)
{
    istringstream iss(line);
    string instruction, rs, rt, rd, offset, imm, opcode, index;

    iss >> instruction;

    cout << instruction << endl;

    if (opcodeMap.find(instruction) == opcodeMap.end())
    {
        throw runtime_error("Unknown instruction: " + instruction);
    }

    opcode = opcodeMap[instruction];

    if (instruction == "ADD" || instruction == "SUB" || instruction == "AND")
    {
        iss >> rd >> rs >> rt;
        cout << rd + " " + " " + rs + " " + rt << endl;
        rd = rd.substr(0, 3);
        rs = rs.substr(0, 3);
        if (registerMap.find(rd) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rd);
        }
        if (registerMap.find(rs) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rs);
        }
        if (registerMap.find(rt) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rt);
        }
        rd = registerMap[rd];
        rs = registerMap[rs];
        rt = registerMap[rt];
        return opcode + rd + rs + rt + "00";
    }
    else if (instruction == "IADD")
    {
        iss >> rd >> rs >> imm;
        rd = rd.substr(0, 3);
        rs = rs.substr(0, 3);
        if (registerMap.find(rd) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rd);
        }
        if (registerMap.find(rs) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rs);
        }
        rd = registerMap[rd];
        rs = registerMap[rs];
        imm = bin(stoi(imm));
        return opcode + rd + rs + "00000" + "\n" + imm;
    }
    else if (instruction == "LDM")
    {
        iss >> rd >> imm;
        rd = rd.substr(0, 3);
        if (registerMap.find(rd) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rd);
        }
        rd = registerMap[rd];
        imm = bin(stoi(imm));
        return opcode + rd + "00000000" + "\n" + imm;
    }
    else if (instruction == "LDD")
    {
        iss >> rt >> offset;
        rt = rt.substr(0, 3);
        if (registerMap.find(rt) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rt);
        }
        rt = registerMap[rt];
        size_t pos = offset.find('(');
        rs = offset.substr(pos + 1, offset.length() - pos - 2);
        if (registerMap.find(rs) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rt);
        }
        rs = registerMap[rs];

        imm = offset.substr(0, pos);
        imm = bin(stoi(imm));
        return opcode + rt + rs + "00000" + "\n" + imm;
    }
    else if (instruction == "STD")
    {
        iss >> rt >> offset;
        rt = rt.substr(0, 3);
        if (registerMap.find(rt) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rt);
        }
        rt = registerMap[rt];
        size_t pos = offset.find('(');
        rs = offset.substr(pos + 1, offset.length() - pos - 2);
        if (registerMap.find(rs) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rt);
        }
        rs = registerMap[rs];

        imm = offset.substr(0, pos);
        imm = bin(stoi(imm));
        return opcode + "000" + rt + rs + "00" + "\n" + imm;
    }
    else if (instruction == "MOV" || instruction == "INC" || instruction == "NOT")
    {
        iss >> rd >> rs;
        rd = rd.substr(0, 3);
        if (registerMap.find(rd) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rd);
        }
        if (registerMap.find(rs) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rs);
        }
        rd = registerMap[rd];
        rs = registerMap[rs];
        return opcode + rd + rs + "00000";
    }
    else if (instruction == "NOP" || instruction == "HLT" || instruction == "SETC" || instruction == "RET" || instruction == "RTI")
    {
        return opcode + "00000000000";
    }
    else if (instruction == "INT")
    {
        iss >> index;

        return opcode + "0000000000" + index;
    }
    else if (instruction == "OUT" || instruction == "PUSH" || instruction == "JZ" ||
             instruction == "JN" || instruction == "JC" || instruction == "JMP" || instruction == "CALL")
    {
        iss >> rs;
        if (registerMap.find(rs) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rs);
        }
        rs = registerMap[rs];
        return opcode + "000" + rs + "00000";
    }
    else if (instruction == "IN" || instruction == "POP")
    {
        iss >> rd;
        if (registerMap.find(rd) == registerMap.end())
        {
            throw runtime_error("Unknown register: " + rd);
        }
        rd = registerMap[rd];
        return opcode + rd + "00000000";
    }

    return "";
}

int main()
{
    filesystem::path current_path(__FILE__);
    filesystem::path directory = current_path.parent_path();
    filesystem::path program = directory / "program.txt";
    filesystem::path IM = directory / "IM.txt";

    ifstream inputFile(program);
    ofstream outputFile(IM);

    if (!inputFile.is_open() || !outputFile.is_open())
    {
        cerr << "Error opening input or output file!" << endl;
        return 1;
    }

    string line;
    int lineNumber = 1;

    while (getline(inputFile, line))
    {
        try
        {
            string instruction = parseInstruction(line);
            outputFile << instruction << endl;
        }
        catch (const exception &e)
        {
            cerr << "Error on line " << lineNumber << ": " << e.what() << endl;
        }
        lineNumber++;
    }

    inputFile.close();
    outputFile.close();

    cout << "Assembly completed. Check IM.txt for results." << endl;
    return 0;
}
