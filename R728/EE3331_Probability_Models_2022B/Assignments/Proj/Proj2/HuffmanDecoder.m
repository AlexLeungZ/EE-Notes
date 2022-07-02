function deco = huffmanDecoder( sig, dict , debug )
%   HUFFMANDECO Huffman decoder.
%   ----------------------------------------------------------------------- 
%   DECO = HUFFMANDECO( SIG, DICT, DECO ) decodes the numeric Huffman code 
%   vector (SIG) using the code dictionary (DICT). The encoded signal must
%   be generated by the HUFFMANENCO_ function. The code dictionary must be
%   generated using the HUFFMANDICT_ function.
% 
%   Example of usage:
% 
%       alphabet = {'x' 'y' 'z' 'w' 'k'}; % Alphabet vector                               
%       prob = [0.1 0.6 0.05 0.15 0.10];  % Probability vector   
%       % Random text
%       dict = huffmandict_( alphabet, prob, 0 )
%       x = alphabet(randsrc(1,7,[1:length(prob); prob]))  
%       encoded = huffmanenco_(x,dict)
%       decoded = huffmandeco_(encoded,dict)
% 
%       Command Window (Output)
% 
%       dict = 
%           symbol: {'x'  'y'  'z'  'w'  'k'}
%           code: {'110'  '0'  '111'  '100'  '101'}
%       x = 
%           'y'    'y'    'y'    'y'    'y'    'z'    'y'
%       encoded =
%           000001110
%       decoded =  
%           'y'    'y'    'y'    'y'    'y'    'z'    'y'
%    
%    See also HUFFMANDICT_, HUFFMANENCO_.
% 
%   ----------------------------------------------------------------------- 
% 
%   --- Error checking ------------------------
% 
    % Check if the input signal is a vector
    [m,n] = size(sig);
    if ( m ~= 1 && n ~= 1)
        error('The input signal must be a vector.');
    end
    
     % Check if the input dictionary is a struct
    if ( ~isstruct(dict) )
        error('The input dictionary must be a struct.');
    end
% 
%   --- /Error checking ------------------------
% 
%   --- Main Function   ------------------------
% 
    % Check for debug argument
    debug_ = 0; % Global Variable
    if ( nargin > 2 && debug == 1 )
        debug_ = 1;
        fileID = fopen(strcat(get_timestamp, '_huffmandeco_.txt'),'w'); % Open the bebug file.
        fprintf(fileID,'Debug Log - huffmanenco_\n----------------------------\n');
        fprintf(fileID,'\nInput Signal :\n\t');
        for i = 1:length(sig)
            fprintf(fileID,'%s',sig(i));
        end        
    end
    if debug_
        fprintf(fileID,'\n\nDecodding each symbol :\n----------------------------\n');
    end
    deco = []; % Output signal vector initialize.
    sig_ = sig;
    codepos_ = 1;
    while( ~isempty(sig_) ) % For each set of bits in the signal.
        temp_ = sig_(codepos_); % Get first bit(char). 
        dictb = dict; % Get a backup of the input dictionary.
        while (1) % Loop
            [flag,dict_] = found_match( temp_, codepos_, dictb); % Get a sub dictionary.
            if ( flag == 0 ) % If there is an error at the encoded word.
                error('The encoded signal contains a code which is not present in the dictionary.');
            end
            dictb = dict_; % Update loop dictionary.
            if ( length(dictb.code) ~= 1 ) % Until one codeword left.
                codepos_ = codepos_ + 1;   % Match second bit(char).
                temp_ = sig_(codepos_);    % Get first char 
            else % Found the symbol
                if ( debug_ == 1 )
                    fprintf(fileID,'\tCodeword {"%s"}.\n\t\tFound symbol "%s" after %d iterations.\n', dictb.code{1},dictb.symbol{1},codepos_); % Write encryption to the bebug file.
                end
                codepos_ = 1; % Reset position.
                sig_ = sig_(length(dictb.code{1})+1:end); % Update the input signal.
                break;
            end        
        end
        deco = [deco dictb.symbol]; % Append char to decoded signal.
    end
    % Debug logging.
    if ( debug_ == 1 )
        fprintf(fileID,'----------------------------\n\nDecompresed Signal :\n\t'); % Write encryption to the bebug file.
        for i = 1:length(deco)
            fprintf(fileID,'%s',deco{i});
        end
        fclose(fileID); % Close the bebug file.
    end
end
% 
% --- /Main Function   ------------------------
% 
% --- Helper Function   ------------------------
%   HUFFMANDECO Huffman decoder.
%   ----------------------------------------------------------------------- 
%   [FLAG,DICT_] = FOUND_MATCH( CODE, POS, DICT ).
%   Given an input dictionary (DICT) try to found matches of the input code
%   (CODE) at position of code (POS). OUTPUT subdictionary (DICT_) of original
%   dictionary countains matched symbols and their code represantation.
%   ----------------------------------------------------------------------- 
%   --- Function Body   ------------------------
    function [flag,dict_] = found_match( code, pos, dict )
        dict_.symbol={}; dict_.code={}; % Create a dictionary structure.
        j = 1;    % Iterator.
        flag = 0; % Flag for error.
        for i = 1:length(dict.code) % For each code in dictionary.
            if ( strcmp(dict.code{i}(pos), code) ) % If inpute code matches 
                 flag = 1; % No error match.
                 dict_.symbol(j) = dict.symbol(i); % Get the symbol that matches.
                 dict_.code(j) = dict.code(i);     % Get the code of the matched symbol.
                 j = j + 1;                        % Prepare for a next symbol.
            end
        end
    end
%   --- Function Body   ------------------------
% ---/ Helper Function   ------------------------
% 
% % EOF -- huffmadeco_