FactoryBot.define do
  factory :response, class: Hash do
    total_records { 2 }
    related_tags { [{tag: 'Tag1', count: 1 }, {tag: 'Tag5', count: 3 }] }
    records { [ {uuid: '5c9902638cd3863c359dc8c6', name: 'File1' }, {uuid: '5c9902638cd3863c359dc8c6', name: 'File1' } ] }
  end

  initialize_with { attributes }
end

{
"total_records": 2,
"related_tags": [
  {
"tag": "Tag1",
"count": 1
},
  {
"tag": "Tag5",
"count": 3
}
],
"records": [
  {
"uuid": "5c9902638cd3863c359dc8c6",
"name": "File1"
},
  {
"uuid": "5c9902ee8cd3863c359dc8c8",
"name": "File3"
}
],
}
