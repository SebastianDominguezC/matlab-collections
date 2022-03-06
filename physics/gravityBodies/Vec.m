% Vector Vec regarding an origin
classdef Vec < handle

    properties
        x
        y
        z
    end

    properties (Dependent)
        Magnitude
    end

    methods

        function p = Vec(x, y, z)
            p.x = x;
            p.y = y;
            p.z = z;
        end

        function m = get.Magnitude(obj)
            m = sqrt(obj.x^2 + obj.y^2 + obj.z^2);
        end

        function d = DirVecOther(obj, other)
            x_d = other.x - obj.x;
            y_d = other.y - obj.y;
            z_d = other.z - obj.z;
            d = Vec(x_d, y_d, z_d);
        end

        function d = UnitDirVecOther(obj, other)
            dirVec = DirVecOther(obj, other);
            m = dirVec.Magnitude;
            x_d = dirVec.x / m;
            y_d = dirVec.y / m;
            z_d = dirVec.z / m;
            d = Vec(x_d, y_d, z_d);
        end

        function s = Scale(obj, a)
            s = Vec(0, 0, 0);
            s.x = a * obj.x;
            s.y = a * obj.y;
            s.z = a * obj.z;
        end

        function s = Add(obj, other)
            s = Vec(0, 0, 0);
            s.x = obj.x + other.x;
            s.y = obj.y + other.y;
            s.z = obj.z + other.z;
        end

    end

end
