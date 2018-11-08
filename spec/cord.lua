#!/usr/bin/env tarantool

-- Expose Tarantool
box.cfg {
  listen = 3301,
  background = false,
  custom_proc_title = 'cord',
}

-- Initial setup
box.once("bootstrap", function()
  local links = box.schema.create_space('test')
  box.schema.user.create('web', {password = '123456'})
  box.schema.user.grant('web', 'read,write,execute', 'universe')
end)
