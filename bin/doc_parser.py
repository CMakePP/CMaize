import os
import re

def parse_file(file, docs):
    #Get a list of functions in the file (note regex also grabs function() from
    #endfunction()
    fxn_name = re.compile(r"""function\(.*\)""")
    f_contents = file.read()
    fxns = re.findall(fxn_name, f_contents)
    for fxn_i in fxns:
        if fxn_i == "function()":
            continue
        escaped_fxn = fxn_i.replace('(',"\(").replace(')',"\)")
        fxn_doc = re.compile(r"""## ((?:.*\n)*){}""".format(escaped_fxn))
        doc = re.search(fxn_doc, f_contents)
        if doc == None:
            print("WARNING: No documentation for fxn {}".format(fxn_i))
            continue
        #Still has the #'s from the block comment, get rid of those by...

        #...assuming there's a space between the # and the comment
        doc = doc.group(1).replace('# ', '')

        #...and now clear any residual #, like those making blank lines
        doc = doc.replace('#', '')

        #Grab the 1st argument to function() (that's the fxn's name)
        fxn_i = fxn_i.replace('(', ' ').replace(')', '')
        fxn_name = fxn_i.split()[1]

        #Rest of the args are the parameters
        fxn_params = fxn_i.split()[2:]

        #Figure out the prefix on the variables by skimming fxn's name
        fxn_name_parts = fxn_name.split('_')
        letters = [word[0] if len(word) else '_' for word in fxn_name_parts]
        abbrv = ''.join(letters)

        #Take prefix off of the arguments
        fxn_params = [ var.replace(abbrv + '_', '') for var in fxn_params]

        #Piece the actual reST function command together
        fxn_line = ".. function:: {}(".format(fxn_name)
        for var in fxn_params[:-1]:
            fxn_line = "{}<{}> ".format(fxn_line, var)
        fxn_line = "{}<{}>)".format(fxn_line, fxn_params[-1])

        fxn_line = fxn_line + "\n"
        for line in doc.split('\n'):
            fxn_line = "{}\n    {}".format(fxn_line, line)
        docs[fxn_name] = fxn_line



def parse_dir(root_dir, docs):
    for file in os.listdir(root_dir):
        full_file = os.path.join(root_dir, file)
        if os.path.isdir(full_file):
            print(full_file)
            sub_docs = {}
            parse_dir(full_file, sub_docs)
            for k,v in sub_docs.items():
                docs[os.path.join(file, k)] = v
        else:
            with open(full_file, "r") as f:
                parse_file(f, docs)

def main():
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    root_dir = os.path.dirname(curr_dir)
    source_dir = os.path.join(root_dir, "cmake")

    docs = {}
    parse_dir(source_dir, docs)

    output_dir = os.path.join(root_dir, "docs", "source", "apis")

    for k,v in docs.items():
        with open(os.path.join(output_dir,k) + ".rst", "w") as f:
            f.write(v)


if __name__ == "__main__":
    main()
