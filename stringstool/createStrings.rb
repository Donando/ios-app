#!/bin/ruby

# 10/06/2015
# Constantine Karlis. dino@constantinekarlis.com
# transforms a .csv into an Xcode .strings file
# 13/01/2016
# Joachim Deelen: Enhanced to download TSV-File and to read strings for different locales from table-columns

require 'open-uri'
require 'fileutils'

class StringsContainer
    @locale
    @strings
    attr_reader :locale, :strings
    def initialize(locale)
        @locale = locale
        @strings = Hash.new
    end
    
    def addString(key, string)
        @strings[key] = string
    end
    
end

def urlReachable?(url)
    begin
        true if open(url)
    rescue
        false
    end
end

docsURL = "https://docs.google.com"
currentDir = File.dirname(__FILE__)
fallbackFileName = "Translations.tsv"
fallbackFilePath = "#{currentDir}/#{fallbackFileName}"
projectDir = ENV["PROJECT_DIR"]
projectName = ENV["PROJECT_NAME"]
outFileBaseDir = projectDir + "/" + projectName
outFileNameStrings = "Donando.strings"
outFileNamePlist = "InfoPlist.strings"

stringsContainers = Array.new

tsvFile = nil

p "Trying GoogleDocs"

unless urlReachable?(docsURL)
    warning = "CAUTION: Using local translations"
    p warning
    system("say #{warning}")
    tsvFile = File.open(fallbackFilePath, "rb")
else
    # Don't allow downloaded files to be created as StringIO. Force a tempfile to be created.
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0
    p "Downloading latest translations"
    tsvFile = open("#{docsURL}/spreadsheets/d/1cuMekFo-hLozDObTiwP0GiNQj2IAYqYoTekptgOej98/export?format=tsv")
    if FileTest.exist?(fallbackFilePath)
        FileUtils.rm(fallbackFilePath)
    end
    FileUtils.cp(tsvFile.path, fallbackFilePath)
end

tsvFile.each_line { |line|
    locales = line.split("\t")
    key = locales.shift
    if tsvFile.lineno == 1
        locales.each { |locale|
            stringsContainers.push(StringsContainer.new(locale.strip))
        }
    else
        localeIndex = 0
        locales.each { |string|
            stringsContainers[localeIndex].addString(key, string.strip)
            localeIndex += 1
    }
    end
}

stringsContainers.each { |stringContainer|
    locale = stringContainer.locale
    variations = stringContainer.locale.split(',')
    variations.each { |locale|
        strippedLocale = locale.strip
        unless locale.include?("(") then
            localeDir = outFileBaseDir + "/" + strippedLocale + ".lproj"
            unless File.directory?(localeDir)
                Dir.mkdir(localeDir)
            end
            stringsOut = ""
            plistOut = ""
            stringContainer.strings.each { |key, value|
                value = value.gsub("\"", "\\\"")
                outkey = key.dup
                slice = outkey.slice!("InfoPlist.")
                out = "\"#{outkey}\" = \"#{value}\";\n"
                unless slice == nil  then
                    plistOut += out
                    else
                    stringsOut += out
                end
            }
            if plistOut.size > 0 then
                File.write("#{localeDir}/#{outFileNamePlist}", plistOut)
            end
            if stringsOut.size > 0 then
                File.write("#{localeDir}/#{outFileNameStrings}", stringsOut)
            end
            p "Wrote localizations for #{locale} into #{localeDir}"
        end
    }
}

=begin
 require 'csv'

 class String
 def encodeCSVQuotes
 self.gsub("\"\"", "&quot;")
 end
 
 def decodeCSVQuotes
 self.gsub("&quot;", "\\\"")
 end
 end
 
currentDir = File.dirname(__FILE__)
inFileName = "#{currentDir}/Lounge App_ Translations - DE Translation.csv"
outFileName = "Localizable.strings"
numFiles = 0
inString = File.read(inFileName).encodeCSVQuotes
rows = CSV.parse(inString)

cols = rows.shift

rows.sort_by!{ |row| row[0].downcase }

(1...cols.length).each do |i|
  out = ""
  rows.each do |row|
    out += "\"#{row[0]}\" = \"#{row[i].decodeCSVQuotes}\";\n"
  end

  dir = "#{currentDir}/#{cols[i]}"
  unless File.directory?(dir)
    Dir.mkdir(dir)
  end
  File.write("#{dir}/#{outFileName}", out)
  numFiles += 1
end

puts "#{numFiles} file(s) created"
=end
