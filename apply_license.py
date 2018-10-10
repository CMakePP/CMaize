import os

def make_license(year, author, comment_char):
    return """
{0} Copyright {1} {2}
{0}
{0} Licensed under the Apache License, Version 2.0 (the "License");
{0} you may not use this file except in compliance with the License.
{0} You may obtain a copy of the License at
{0}
{0}     http://www.apache.org/licenses/LICENSE-2.0
{0}
{0} Unless required by applicable law or agreed to in writing, software
{0} distributed under the License is distributed on an "AS IS" BASIS,
{0} WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
{0} See the License for the specific language governing permissions and
{0} limitations under the License.""".format(comment_char, year, author)

def main() :
    year = "2018"
    author = "Ryan M. Richard"
    comment_char = '#'
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    new_license = make_license(year, author, comment_char)
    for filename in os.listdir(os.path.join(curr_dir, "cmake")):
        file_path = os.path.join(curr_dir, "cmake", filename)
        with open(file_path, "r") as f:
            with open(file_path +".temp", "w") as g:
                g.write(new_license + "\n")
                for l in f.readlines():
                    g.write(l)


if __name__ == "__main__":
    main()
