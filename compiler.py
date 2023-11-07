from rply import LexerGenerator
from rply.lexer import LexingError
import sys

class Compiler:
    def __init__(self, file_input_name, file_output_name):
        self.reader, self.writer = self.open_files(file_input_name, file_output_name)
        self.lexer = self.create_lexer()
        self.opcode = {
            "HLT": "0000",
            "IN": "0001",
            "OUT": "0010",
            "PUSHIP": "0011",
            "PUSH": "0100",
            "DROP": "0101",
            "DUP": "0110",
            "ADD": "1000",
            "SUB": "1001",
            "NAND": "1010",
            "SLT": "1011",
            "SHL": "1100",
            "SHR": "1101",
            "JEQ": "1110",
            "JMP": "1111",
            "ZERO": "0000"
        }

    def close(self):
        self.reader.close
        self.writer.close

    def open_files(self, file_input_name, file_output_name):
        reader = open(file_input_name, "r")
        writer = open(file_output_name, "w")

        return reader, writer

    def create_lexer(self):
        lexer_generator = LexerGenerator()

        lexer_generator.add("HLT", r"HLT")
        lexer_generator.add("IN", r"IN")
        lexer_generator.add("OUT", r"OUT")
        lexer_generator.add("PUSHIP", r"PUSHIP")
        lexer_generator.add("PUSH", r"PUSH")
        lexer_generator.add("IMMEDIATE", r" (\+|\-)?[0-9]+")
        lexer_generator.add("DROP", r"DROP")
        lexer_generator.add("DUP", r"DUP")
        lexer_generator.add("ADD", r"ADD")
        lexer_generator.add("SUB", r"SUB")
        lexer_generator.add("NAND", r"NAND")
        lexer_generator.add("SLT", r"SLT")
        lexer_generator.add("SHL", r"SHL")
        lexer_generator.add("SHR", r"SHR")
        lexer_generator.add("JEQ", r"JEQ")
        lexer_generator.add("JMP", r"JMP")

        lexer_generator.add("LINE_BREAK", r"\n")
        lexer_generator.add("EMPTY", r" |\t")
        
        lexer = lexer_generator.build()

        return lexer

    def compile(self):
        try:
            for token in self.lexer.lex(self.reader.read().upper()):
                    if token.name == "IMMEDIATE":
                        out = bin(~int(token.value) + 1)
                        self.writer.write(str(out)[2:])
                    elif token.name == "LINE_BREAK" or token.name == "EMPTY":
                        self.writer.write(token.value)
                    elif token.name == "PUSH":
                        self.writer.write(self.opcode[token.name])
                    else:
                        self.writer.write(self.opcode[token.name])
                        self.writer.write(self.opcode["ZERO"])

        except LexingError as error:
            print("LexicalError: At line %d." % token.getsourcepos().lineno)

def main():
    try:
        compiler = Compiler(sys.argv[1], sys.argv[2])
        compiler.compile()
        compiler.close()

    except FileNotFoundError as error:
        print("FileNotFoundError: The file '%s' does not exist." %(error.filename))

if __name__ == "__main__":
    main()
    sys.exit(0)

# python compiler.py bin/code.bin bin/firmware.bin