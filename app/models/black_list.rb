class BlackList < ActiveHash::Base
  fields :id, :word
  create id: 1, word: 'fuck'
  create id: 2, word: 'pussy'
  create id: 3, word: 'dkm'
  create id: 4, word: 'bitch'
  create id: 5, word: 'asshole'
  create id: 6, word: 'vkl'
  create id: 7, word: 'bastard'
  create id: 8, word: 'shit'
  create id: 9, word: 'dickhead'
end