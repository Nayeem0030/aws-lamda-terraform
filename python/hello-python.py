def lamda_handler(event, context):
  message= "Hello' {} ! '.format(event ['key1'])
  return {
  'message' : message
  }
