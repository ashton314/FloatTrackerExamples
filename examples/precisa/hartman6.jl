using FloatTracker: TrackedFloat64, write_out_logs, set_logger
using Random
using Distributions: Uniform

set_logger(filename="hartman6", buffersize=1)

function tf(x)
  TrackedFloat64(x)
end

function hartman6(X1,X2,X3,X4,X5,X6)
  E1 = 10.0 * ((X1 - 0.1312) * (X1 - 0.1312)) + 3.0 * ((X2 - 0.1696) * (X2 - 0.1696))
          + 17.0 * ((X3 - 0.5569) * (X3 - 0.5569)) + 3.5 * ((X4 - 0.0124) * (X4 - 0.0124))
          + 1.7 * ((X5 - 0.8283) * (X5 - 0.8283)) + 8.0 * ((X6 - 0.5886) * (X6 - 0.5886))
  E2 = 0.05 * ((X1 - 0.2329) * (X1 - 0.2329)) + 10.0 * ((X2 - 0.4135) * (X2 - 0.4135))
          + 17.0 * ((X3 - 0.8307) * (X3 - 0.8307)) + 0.1 * ((X4 - 0.3736) * (X4 - 0.3736))
          + 8.0 * ((X5 - 0.1004) * (X5 - 0.1004)) + 14.0 * ((X6 - 0.9991) * (X6 - 0.9991))

  E3 = 3.0 * ((X1 - 0.2348) * (X1 - 0.2348)) + 3.5 * ((X2 - 0.1451) * (X2 - 0.1451))
          + 1.7 * ((X3 - 0.3522) * (X3 - 0.3522)) + 10.0 * ((X4 - 0.2883) * (X4 - 0.2883))
          + 17.0 * ((X5 - 0.3047) * (X5 - 0.3047)) + 8.0 * ((X6 - 0.665) * (X6 - 0.665))

  E4 = 17.0 * ((X1 - 0.4047) * (X1 - 0.4047)) + 8.0 * ((X2 - 0.8828) * (X2 - 0.8828))
          + 0.05 * ((X3 - 0.8732) * (X3 - 0.8732)) + 10.0 * ((X4 - 0.5743) * (X4 - 0.5743))
          + 0.1 * ((X5 - 0.1091) * (X5 - 0.1091)) + 14.0 * ((X6 - 0.0381) * (X6 - 0.0381))
  -((1 * exp(-E1)) + (1.2 * exp(-E2)) + (3 * exp(-E3)) + (3.2 * exp(-E4)))
end

nn = 8

for X1 in rand(Uniform(0, 1), nn)
  for X2 in rand(Uniform(0, 1), nn)
    for X3 in rand(Uniform(0, 1), nn)
      for X4 in rand(Uniform(0, 1), nn)
        for X5 in rand(Uniform(0, 1), nn)
          for X6 in rand(Uniform(0, 1), nn)
            hartman6(tf(X1), tf(X2), tf(X3), tf(X4), tf(X5), tf(X6))
          end
        end
      end
    end
  end
end

write_out_logs()
